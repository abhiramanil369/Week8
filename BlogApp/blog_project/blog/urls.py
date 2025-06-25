from django.urls import path
from .views import LoginAPI, PostListAPI, PostDetailAPI, CreatePostAPI

urlpatterns = [
    path('api/login/', LoginAPI.as_view()),
    path('api/posts/', PostListAPI.as_view()),
    path('api/posts/<int:pk>/', PostDetailAPI.as_view()),
    path('api/posts/create/', CreatePostAPI.as_view()),
]
