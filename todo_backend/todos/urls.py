from django.urls import path
from .views import TodoListCreateView, TodoDetailView, todo_app

urlpatterns = [
    path('', todo_app, name='todo-home'),  # This serves your HTML frontend
    path('todos/', TodoListCreateView.as_view(), name='todo-list-create'),
    path('todos/<int:pk>/', TodoDetailView.as_view(), name='todo-detail'),
]
