package com.vrmg.versegroww

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Color
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import android.view.View
import java.io.File
import com.vrmg.versegroww.R

class VerseWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.verse_widget)
            
            // Get widget data from Flutter
            val prefs = HomeWidgetPlugin.getData(context)
            val verseName = prefs?.getString("verse_name", "Loading...") ?: "Loading..."
            val verseText = prefs?.getString("verse_text", "Please open the app to load today's verse") ?: "Please open the app to load today's verse"
            
            // Get styling data
            val backgroundColor = prefs?.getString("widget_background_color", null)?.toLongOrNull() ?: Color.WHITE.toLong()
            val verseNameColor = prefs?.getString("widget_verse_name_color", null)?.toLongOrNull() ?: Color.BLACK.toLong()
            val verseTextColor = prefs?.getString("widget_verse_text_color", null)?.toLongOrNull() ?: Color.BLACK.toLong()
            val useImageBackground = prefs?.getString("widget_use_image_background", "false") == "true"
            val backgroundImagePath = prefs?.getString("widget_background_image", null)
            
            // Set background
            if (useImageBackground && !backgroundImagePath.isNullOrEmpty()) {
                val file = File(backgroundImagePath)
                if (file.exists()) {
                    try {
                        val bitmap = BitmapFactory.decodeFile(file.absolutePath)
                        if (bitmap != null) {
                            views.setImageViewBitmap(R.id.widget_background, bitmap)
                            views.setViewVisibility(R.id.widget_background, View.VISIBLE)
                            // Make container transparent when using image background
                            views.setInt(R.id.widget_container, "setBackgroundColor", Color.TRANSPARENT)
                        } else {
                            views.setViewVisibility(R.id.widget_background, View.GONE)
                            views.setInt(R.id.widget_container, "setBackgroundColor", backgroundColor.toInt())
                        }
                    } catch (e: Exception) {
                        views.setViewVisibility(R.id.widget_background, View.GONE)
                        views.setInt(R.id.widget_container, "setBackgroundColor", backgroundColor.toInt())
                    }
                } else {
                    views.setViewVisibility(R.id.widget_background, View.GONE)
                    views.setInt(R.id.widget_container, "setBackgroundColor", backgroundColor.toInt())
                }
            } else {
                views.setViewVisibility(R.id.widget_background, View.GONE)
                views.setInt(R.id.widget_container, "setBackgroundColor", backgroundColor.toInt())
            }
            
            // Set verse content
            views.setTextViewText(R.id.verse_text, verseText)
            views.setTextViewText(R.id.verse_name, verseName)
            
            // Set text colors
            views.setTextColor(R.id.verse_text, verseTextColor.toInt())
            views.setTextColor(R.id.verse_name, verseNameColor.toInt())
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
} 