package com.example.project

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class VerseWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.verse_widget)
            
            // Get widget data from Flutter
            val verseName = HomeWidgetPlugin.getData(context)?.getString("verse_name", "John 3:16") ?: "John 3:16"
            val verseText = HomeWidgetPlugin.getData(context)?.getString("verse_text", "For God so loved the world...") ?: "For God so loved the world..."
            
            // Update widget views
            views.setTextViewText(R.id.verse_name, verseName)
            views.setTextViewText(R.id.verse_text, verseText)
            
            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
} 