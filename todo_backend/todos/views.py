import uuid
from django.shortcuts import render
from django.http import JsonResponse
from rest_framework import generics
from .models import Todo
from .serializers import TodoSerializer

# View to serve the HTML template
def todo_app(request):
    return render(request, 'todos/index.html')  # This is your HTML file

# List and Create Todo API (using session to track user_identifier)
class TodoListCreateView(generics.ListCreateAPIView):
    serializer_class = TodoSerializer

    def get_queryset(self):
        # Retrieve the user identifier from the session. If it doesn't exist, generate one
        user_identifier = self.request.session.get('user_identifier')

        if not user_identifier:
            # If no user identifier, generate a new one (using UUID) and store it in the session
            user_identifier = str(uuid.uuid4())
            self.request.session['user_identifier'] = user_identifier
        
        # Return todos associated with the user identifier
        return Todo.objects.filter(user_identifier=user_identifier)

    def perform_create(self, serializer):
        # Automatically use the user identifier from the session
        user_identifier = self.request.session.get('user_identifier')
        
        if not user_identifier:
            # Generate and save a new user identifier if not available
            user_identifier = str(uuid.uuid4())
            self.request.session['user_identifier'] = user_identifier
        
        # Save the todo with the user identifier
        serializer.save(user_identifier=user_identifier)

# Retrieve, Update, and Delete Todo API
class TodoDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer
