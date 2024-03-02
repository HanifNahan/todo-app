from django.db import models

class Todo(models.Model):
    STATUS_CHOICES = (
        ('todo', 'Todo'),
        ('completed', 'Completed'),
    )
    
    title = models.CharField(max_length=100, default='')
    description = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='todo')
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
    
    class Meta:
        ordering = ['-updated']
