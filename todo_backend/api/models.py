from django.db import models

class Todo(models.Model):
  body = models.TextField()
  updated = models.DateTimeField(auto_now=True)
  created = models.DateTimeField(auto_now_add=True)

  def __str__(self):
      return self.body[:50]
  
  class Meta:
    ordering = ['-updated']