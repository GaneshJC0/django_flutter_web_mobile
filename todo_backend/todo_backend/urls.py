from django.contrib import admin
from django.urls import path, include
from todos.views import todo_app  # Import the view that serves index.html

urlpatterns = [
    path('admin/', admin.site.urls),  # Admin site URL
    path('api/', include('todos.urls')),  # API URLs (e.g., /api/todos/)
    path('', todo_app, name='todo-home'),  # Serve the index.html at the root URL
]
