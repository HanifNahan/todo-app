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
            'description': 'Returns a list of todo items'
        },
        {
            'Endpoint': '/todos/<int:pk>/',
            'method': 'GET',
            'body': 'None',
            'description': 'Returns a single todo item by id'
        },
        {
            'Endpoint': '/todos/create/',
            'method': 'POST',
            'body': {'title': "", 'description': "", 'status': ""},
            'description': 'Create a new todo item'
        },
        {
            'Endpoint': '/todos/<int:pk>/update/',
            'method': 'PUT',
            'body': {'title': "", 'description': "", 'status': ""},
            'description': 'Update an existing todo item by id'
        },
        {
            'Endpoint': '/todos/<int:pk>/delete/',
            'method': 'DELETE',
            'body': 'None',
            'description': 'Delete a todo item by id'
        },
    ]
    return Response(routes)

@api_view(['GET'])
def getTodos(request):
    todos = Todo.objects.all()
    serializer = TodoSerializer(todos, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getTodo(request, pk):
    try:
        todo = Todo.objects.get(id=pk)
        serializer = TodoSerializer(todo)
        return Response(serializer.data)
    except Todo.DoesNotExist:
        return Response({"error": "Todo item does not exist"}, status=404)

@api_view(['POST'])
def createTodo(request):
    serializer = TodoSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['PUT'])
def updateTodo(request, pk):
    try:
        todo = Todo.objects.get(id=pk)
        serializer = TodoSerializer(todo, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    except Todo.DoesNotExist:
        return Response({"error": "Todo item does not exist"}, status=404)

@api_view(['DELETE'])
def deleteTodo(request, pk):
    try:
        todo = Todo.objects.get(id=pk)
        todo.delete()
        return Response({"message": "Todo item deleted successfully"}, status=204)
    except Todo.DoesNotExist:
        return Response({"error": "Todo item does not exist"}, status=404)
