from django.contrib import admin
from .models import Todo

# Register the Todo model to make it available in the Django admin interface
@admin.register(Todo)
class TodoAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'is_completed', 'created_at', 'updated_at')  # Fields to display in the list view
    search_fields = ['title']  # Allow searching by title
    list_filter = ['is_completed']  # Add filter for completion status
