package com.oneshelf.one_shelf

import android.graphics.Bitmap
import android.graphics.Matrix
import android.media.MediaMetadataRetriever
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            LOCAL_VIDEO_METADATA_CHANNEL,
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
        } catch (_: Exception) {
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

            val bitmap = retriever.getFrameAtTime(
                targetPositionUs,
                MediaMetadataRetriever.OPTION_CLOSEST_SYNC,
            )

            if (bitmap == null) {
                return null
            }

            val rotation = retriever.extractMetadata(
                MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION,
            )?.toIntOrNull() ?: 0

            val rotatedBitmap = rotateBitmapIfNeeded(bitmap, rotation)

            val stream = ByteArrayOutputStream()
            rotatedBitmap.compress(Bitmap.CompressFormat.JPEG, 85, stream)
            stream.toByteArray()
        } catch (_: Exception) {
            null
        } finally {
            try {
                retriever.release()
            } catch (_: Exception) {
            }
        }
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

    private companion object {
        const val LOCAL_VIDEO_METADATA_CHANNEL =
            "com.oneshelf.one_shelf/local_video_metadata"
    }
}
