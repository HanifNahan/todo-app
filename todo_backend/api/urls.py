from django.urls import path
from . import views

urlpatterns = [
  path('', views.getRoutes),
  path('todos/', views.getTodos),
  path('todos/create/', views.createTodo),
  path('todos/<int:pk>/update/', views.updateTodo),
  path('todos/<int:pk>/delete/', views.deleteTodo),
  path('todos/<int:pk>/', views.getTodo),
]
