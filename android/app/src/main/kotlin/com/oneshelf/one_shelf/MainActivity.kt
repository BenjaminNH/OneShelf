package com.oneshelf.one_shelf

import android.media.MediaMetadataRetriever
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

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

    private companion object {
        const val LOCAL_VIDEO_METADATA_CHANNEL =
            "com.oneshelf.one_shelf/local_video_metadata"
    }
}
