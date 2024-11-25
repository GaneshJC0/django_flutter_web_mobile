from django.db import models
import uuid

class Todo(models.Model):
    user_identifier = models.CharField(max_length=100, default=uuid.uuid4, editable=False)  # Unique identifier for each user
    title = models.CharField(max_length=255)  # Title of the todo task
    is_completed = models.BooleanField(default=False)  # Status to track whether the task is completed
    created_at = models.DateTimeField(auto_now_add=True)  # Automatically set the creation timestamp
    updated_at = models.DateTimeField(auto_now=True)  # Automatically update the timestamp on changes

    def __str__(self):
        return self.title  # This will return the title when you print a Todo object
