from django.shortcuts import render, redirect
from .models import Message

def home(request):
    return render(request, 'chat/home.html')

def room(request, room_name):
    if request.method == 'POST':
        username = request.POST.get('username')
        content = request.POST.get('message')
        if username and content:
            Message.objects.create(room=room_name, username=username, content=content)
            return redirect('room', room_name=room_name)

    messages = Message.objects.filter(room=room_name).order_by('timestamp')
    return render(request, 'chat/room.html', {
        'room_name': room_name,
        'messages': messages
    })