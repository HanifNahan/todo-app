from django.urls import path
from . import views

urlpatterns = [
  path('', views.getRoutes),
  path('todos/', views.getTodos),
  path('todos/create/', views.createTodo),
  path('todos/<str:pk>/update/', views.updateTodo),
  path('todos/<str:pk>/delete/', views.deleteTodo),
  path('todos/<str:pk>/', views.getTodo),
]