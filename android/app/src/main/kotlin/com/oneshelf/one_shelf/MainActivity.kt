package com.oneshelf.one_shelf

import android.graphics.Bitmap
import android.graphics.Matrix
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.util.Size
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private lateinit var nativeDebugLogChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        nativeDebugLogChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NATIVE_DEBUG_LOG_CHANNEL,
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            LOCAL_VIDEO_METADATA_CHANNEL,
            StandardMethodCodec.INSTANCE,
            flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue(),
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "readMetadata" -> {
                    val uri = call.argument<String>("uri")
                    if (uri.isNullOrBlank()) {
                        result.success(emptyMap<String, Any?>())
                        return@setMethodCallHandler
                    }

                    result.success(readLocalVideoMetadata(uri))
                }

                "extractFrame" -> {
                    val uri = call.argument<String>("uri")
                    val positionMs = call.argument<Number>("positionMs")?.toLong() ?: 0L
                    if (uri.isNullOrBlank()) {
                        result.success(null)
                        return@setMethodCallHandler
                    }

                    result.success(extractVideoFrame(uri, positionMs))
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun readLocalVideoMetadata(uriString: String): Map<String, Any?> {
        val retriever = MediaMetadataRetriever()
        return try {
            retriever.setDataSource(this, Uri.parse(uriString))

            val durationMs = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_DURATION,
            )?.toIntOrNull()
            val width = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH,
            )?.toIntOrNull()
            val height = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT,
            )?.toIntOrNull()
            val rotation = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION,
            )?.toIntOrNull()

            val (resolvedWidth, resolvedHeight) = if (rotation == 90 || rotation == 270) {
                Pair(height, width)
            } else {
                Pair(width, height)
            }

            mapOf(
                "durationMs" to durationMs,
                "width" to resolvedWidth,
                "height" to resolvedHeight,
            )
        } catch (error: Exception) {
            emitNativeDebugLog(
                event = "read_metadata_failed",
                fields = mapOf(
                    "uri" to uriString,
                    "error" to (error.message ?: error.toString()),
                    "exceptionType" to error.javaClass.simpleName,
                    "thread" to Thread.currentThread().name,
                ),
            )
            Log.e(TAG, "readLocalVideoMetadata failed uri=$uriString", error)
            emptyMap()
        } finally {
            try {
                retriever.release()
            } catch (_: Exception) {
            }
        }
    }

    private fun extractVideoFrame(uriString: String, positionMs: Long): ByteArray? {
        val retriever = MediaMetadataRetriever()
        return try {
            retriever.setDataSource(this, Uri.parse(uriString))

            val durationMs = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_DURATION,
            )?.toLongOrNull() ?: 0L

            val targetPositionUs = if (positionMs > 0) {
                positionMs * 1000L
            } else {
                val defaultPosition = (durationMs * 0.1).toLong()
                defaultPosition * 1000L
            }

            emitNativeDebugLog(
                event = "extract_frame_start",
                fields = mapOf(
                    "uri" to uriString,
                    "durationMs" to durationMs,
                    "positionMs" to positionMs,
                    "targetUs" to targetPositionUs,
                    "thread" to Thread.currentThread().name,
                ),
            )
            Log.d(
                TAG,
                "extractVideoFrame start uri=$uriString durationMs=$durationMs positionMs=$positionMs targetUs=$targetPositionUs thread=${Thread.currentThread().name}",
            )

            val frameAttempt = tryExtractFrame(
                retriever = retriever,
                uriString = uriString,
                durationMs = durationMs,
                requestedPositionMs = positionMs,
            )
            val bitmap = frameAttempt.bitmap

            if (bitmap == null) {
                emitNativeDebugLog(
                    event = "extract_frame_null_bitmap",
                    fields = mapOf(
                        "uri" to uriString,
                        "durationMs" to durationMs,
                        "positionMs" to positionMs,
                        "targetUs" to targetPositionUs,
                        "attemptedPositionsMs" to frameAttempt.attemptedPositionsMs.joinToString(","),
                        "attemptedOptions" to frameAttempt.attemptedOptions.joinToString(","),
                        "thread" to Thread.currentThread().name,
                    ),
                )
                Log.w(
                    TAG,
                    "extractVideoFrame returned null bitmap uri=$uriString durationMs=$durationMs positionMs=$positionMs targetUs=$targetPositionUs",
                )
                return null
            }

            val rotation = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION,
            )?.toIntOrNull() ?: 0

            val rotatedBitmap = if (frameAttempt.requiresRotationCompensation) {
                rotateBitmapIfNeeded(bitmap, rotation)
            } else {
                bitmap
            }
            emitNativeDebugLog(
                event = "extract_frame_bitmap_ok",
                fields = mapOf(
                    "uri" to uriString,
                    "width" to rotatedBitmap.width,
                    "height" to rotatedBitmap.height,
                    "rotation" to rotation,
                    "usedPositionMs" to frameAttempt.usedPositionMs,
                    "usedOption" to frameAttempt.usedOption,
                    "attemptedPositionsMs" to frameAttempt.attemptedPositionsMs.joinToString(","),
                    "source" to frameAttempt.source,
                    "thread" to Thread.currentThread().name,
                ),
            )
            Log.d(
                TAG,
                "extractVideoFrame bitmap ok uri=$uriString width=${rotatedBitmap.width} height=${rotatedBitmap.height} rotation=$rotation thread=${Thread.currentThread().name}",
            )

            val stream = ByteArrayOutputStream()
            rotatedBitmap.compress(Bitmap.CompressFormat.JPEG, 85, stream)
            stream.toByteArray()
        } catch (error: Exception) {
            emitNativeDebugLog(
                event = "extract_frame_failed",
                fields = mapOf(
                    "uri" to uriString,
                    "positionMs" to positionMs,
                    "error" to (error.message ?: error.toString()),
                    "exceptionType" to error.javaClass.simpleName,
                    "thread" to Thread.currentThread().name,
                ),
            )
            Log.e(
                TAG,
                "extractVideoFrame failed uri=$uriString positionMs=$positionMs",
                error,
            )
            null
        } finally {
            try {
                retriever.release()
            } catch (_: Exception) {
            }
        }
    }

    private fun tryExtractFrame(
        retriever: MediaMetadataRetriever,
        uriString: String,
        durationMs: Long,
        requestedPositionMs: Long,
    ): FrameAttemptResult {
        val attemptedPositionsMs = mutableListOf<Long>()
        val attemptedOptions = mutableListOf<String>()
        val positionsMs = buildCandidatePositionsMs(
            durationMs = durationMs,
            requestedPositionMs = requestedPositionMs,
        )
        val options = listOf(
            MediaMetadataRetriever.OPTION_CLOSEST_SYNC to "closest_sync",
            MediaMetadataRetriever.OPTION_CLOSEST to "closest",
        )

        for (position in positionsMs) {
            for ((option, optionName) in options) {
                attemptedPositionsMs.add(position)
                attemptedOptions.add(optionName)
                val bitmap = retriever.getFrameAtTime(position * 1000L, option)
                if (bitmap != null) {
                    return FrameAttemptResult(
                        bitmap = bitmap,
                        usedPositionMs = position,
                        usedOption = optionName,
                        attemptedPositionsMs = attemptedPositionsMs,
                        attemptedOptions = attemptedOptions,
                        source = "retriever_frame",
                        requiresRotationCompensation = true,
                    )
                }
            }
        }

        attemptedPositionsMs.add(-1L)
        attemptedOptions.add("content_thumbnail")
        val thumbnailBitmap = tryLoadContentThumbnail(uriString)
        if (thumbnailBitmap != null) {
            return FrameAttemptResult(
                bitmap = thumbnailBitmap,
                usedPositionMs = null,
                usedOption = "content_thumbnail",
                attemptedPositionsMs = attemptedPositionsMs,
                attemptedOptions = attemptedOptions,
                source = "content_thumbnail",
                requiresRotationCompensation = false,
            )
        }

        return FrameAttemptResult(
            bitmap = null,
            usedPositionMs = null,
            usedOption = null,
            attemptedPositionsMs = attemptedPositionsMs,
            attemptedOptions = attemptedOptions,
            source = "none",
            requiresRotationCompensation = false,
        )
    }

    private fun tryLoadContentThumbnail(uriString: String): Bitmap? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            return null
        }

        return try {
            val uri = Uri.parse(uriString)
            contentResolver.loadThumbnail(
                uri,
                Size(720, 720),
                null,
            )
        } catch (error: Exception) {
            emitNativeDebugLog(
                event = "content_thumbnail_failed",
                fields = mapOf(
                    "uri" to uriString,
                    "error" to (error.message ?: error.toString()),
                    "exceptionType" to error.javaClass.simpleName,
                    "thread" to Thread.currentThread().name,
                ),
            )
            null
        }
    }

    private fun buildCandidatePositionsMs(
        durationMs: Long,
        requestedPositionMs: Long,
    ): List<Long> {
        val candidates = linkedSetOf<Long>()
        fun addCandidate(raw: Long?) {
            if (raw == null) {
                return
            }
            val bounded = when {
                durationMs <= 0L -> raw.coerceAtLeast(0L)
                durationMs <= 1L -> 0L
                else -> raw.coerceIn(0L, durationMs - 1L)
            }
            candidates.add(bounded)
        }

        if (requestedPositionMs > 0L) {
            addCandidate(requestedPositionMs)
        }
        if (durationMs > 0L) {
            addCandidate((durationMs * 0.1).toLong())
            addCandidate(1000L)
            addCandidate(5000L)
            addCandidate((durationMs * 0.25).toLong())
            addCandidate((durationMs * 0.5).toLong())
        } else {
            addCandidate(0L)
            addCandidate(1000L)
            addCandidate(5000L)
        }

        return candidates.toList()
    }

    private fun rotateBitmapIfNeeded(bitmap: Bitmap, rotation: Int): Bitmap {
        if (rotation == 0 || rotation == 360) {
            return bitmap
        }

        val matrix = Matrix()
        matrix.postRotate(rotation.toFloat())
        val rotated = Bitmap.createBitmap(
            bitmap,
            0,
            0,
            bitmap.width,
            bitmap.height,
            matrix,
            true,
        )
        if (rotated != bitmap) {
            bitmap.recycle()
        }
        return rotated
    }

    private fun emitNativeDebugLog(
        scope: String = "native_video",
        event: String,
        fields: Map<String, Any?> = emptyMap(),
    ) {
        if (!::nativeDebugLogChannel.isInitialized) {
            return
        }
        try {
            Handler(Looper.getMainLooper()).post {
                nativeDebugLogChannel.invokeMethod(
                    "log",
                    mapOf(
                        "scope" to scope,
                        "event" to event,
                        "fields" to fields,
                    ),
                )
            }
        } catch (_: Exception) {
        }
    }

    private companion object {
        const val TAG = "OneShelfVideoFrame"
        const val LOCAL_VIDEO_METADATA_CHANNEL =
            "com.oneshelf.one_shelf/local_video_metadata"
        const val NATIVE_DEBUG_LOG_CHANNEL =
            "com.oneshelf.one_shelf/native_debug_log"
    }

    private data class FrameAttemptResult(
        val bitmap: Bitmap?,
        val usedPositionMs: Long?,
        val usedOption: String?,
        val attemptedPositionsMs: List<Long>,
        val attemptedOptions: List<String>,
        val source: String,
        val requiresRotationCompensation: Boolean,
    )
}
