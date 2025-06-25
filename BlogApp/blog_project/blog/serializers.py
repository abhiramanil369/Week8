from rest_framework import serializers
from .models import Post
from django.contrib.auth.models import User

class PostSerializer(serializers.ModelSerializer):
    author = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Post
        fields = ['id','title','summary','content','author','created_at']

    class LoginSerailizer(serializers.Serializer):
        username = serializers.CharField()
        password = serializers.CharField()
        