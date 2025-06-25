from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import permissions, status
from .models import Post
from .serializers import PostSerializer, LoginSerializer
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token

# Create your views here.
