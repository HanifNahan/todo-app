from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import TodoSerializer
from .models import Todo

@api_view(["GET"])
def getRoutes(request):
    """
    Get routes using the GET method
    """
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
    """
    This function is a view for getting all todos. It takes a request object as a parameter and returns the serialized data of all todos.
    """
    todos = Todo.objects.all()
    serializer = TodoSerializer(todos, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getTodo(request, pk):
    """
    Retrieve a specific todo item by its id using a GET request.

    Parameters:
    - request: the request object containing metadata about the HTTP request
    - pk: the primary key of the todo item to be retrieved

    Returns:
    - Response object containing the serialized todo item data
    - Response object with an error message and status code 404 if the todo item does not exist
    """
    try:
        todo = Todo.objects.get(id=pk)
        serializer = TodoSerializer(todo)
        return Response(serializer.data)
    except Todo.DoesNotExist:
        return Response({"error": "Todo item does not exist"}, status=404)

@api_view(['POST'])
def createTodo(request):
    """
    A function to create a new Todo using the POST method.
    """
    serializer = TodoSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['PUT'])
def updateTodo(request, pk):
    """
    Update a todo item with the given ID using the data from the request.
    
    Parameters:
    - request: the HTTP request object
    - pk: the ID of the todo item to be updated
    
    Returns:
    - If the update is successful, returns the updated todo item data
    - If the request data is invalid, returns the serializer errors with status code 400
    - If the todo item with the given ID does not exist, returns an error response with status code 404
    """
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
    """
    A view function to delete a Todo item by its primary key.

    Args:
        request: The HTTP DELETE request object.
        pk: The primary key of the Todo item to be deleted.

    Returns:
        A Response object with a success message if the Todo item is deleted successfully, 
        or an error message if the Todo item does not exist.
    """
    try:
        todo = Todo.objects.get(id=pk)
        todo.delete()
        return Response({"message": "Todo item deleted successfully"}, status=204)
    except Todo.DoesNotExist:
        return Response({"error": "Todo item does not exist"}, status=404)
