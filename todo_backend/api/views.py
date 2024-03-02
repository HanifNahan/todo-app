from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import TodoSerializer
from .models import Todo

@api_view(["GET"])
def getRoutes(request):
  routes = [
    {
      'Endpoint': '/todos/',
      'method': 'GET',
      'body': 'None',
      'description': 'Returns an array of notes'
    },
    {
      'Endpoint': '/todos/id',
      'method': 'GET',
      'body': 'None',
      'description': 'Returns single todo object'
    },
    {
      'Endpoint': '/todos/create/',
      'method': 'POST',
      'body': {'body': ""},
      'description': 'Create new todo'
    },
    {
      'Endpoint': '/todos/id/update/',
      'method': 'PUT',
      'body': {'body': ""},
      'description': 'Update todo'
    },
    {
      'Endpoint': '/todos/id/delete/',
      'method': 'DELETEU',
      'body': 'None',
      'description': 'Delete todo'
    },
  ]
  return Response(routes)

@api_view(['GET'])
def getTodos(request):
  todo = Todo.objects.all()
  print("hello")
  serializer = TodoSerializer(todo, many=True)
  return Response(serializer.data)

@api_view(['GET'])
def getTodo(request, pk):
  todo = Todo.objects.get(id=pk)
  serializer = TodoSerializer(todo, many=False)
  return Response(serializer.data)

@api_view(['POST'])
def createTodo(request):
  data = request.data
  todo = Todo.objects.create(
    body = data['body']
  )
  serializer = TodoSerializer(todo, many=False)
  return Response(serializer.data)

@api_view(['PUT'])
def updateTodo(request, pk):
  data = request.data
  todo = Todo.objects.get(id=pk)
  serializer = TodoSerializer(todo, data=data)
  if serializer.is_valid():
    serializer.save()
  return Response(serializer.data)

@api_view(['DELETE'])
def deleteTodo(request, pk):
  todo = Todo.objects.get(id=pk)
  todo.delete()
  return Response({"message": "Deleted successfully!"})