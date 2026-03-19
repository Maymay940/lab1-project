from .models import WaterMeter, Request, ReadingPosition, User
from django.shortcuts import render, get_object_or_404, redirect
from django.db import connection
from django.utils import timezone


# получение текущего пользователя (для заявок, потом понадобится)
def get_current_user():
    # возвращает первого пользователя из БД (пока что пусть так будет)
    return User.objects.first()


def meter_list(request):  # get список всех счетчиков
    search_query = request.GET.get("search", "")  # поисковый запрос из URL

    # все счетчики на глав странице (получаем)
    meters = WaterMeter.objects.filter(is_active=True)

    if search_query:
        meters = meters.filter(address__icontains=search_query)  # фильтр по адресу если есть

    # для заявок используем пользователя (потом, когда сделаю)
    current_user = get_current_user()
    draft_request = Request.objects.filter(status="draft", user=current_user).first()
    if draft_request:
        draft_request.positions_count = ReadingPosition.objects.filter(
            request=draft_request
        ).count()

    context = {
        "meters": meters,  # счетчики
        "draft_request": draft_request,
        "search_query": search_query,
    }
    return render(request, "meters/meter_list.html", context)


def meter_detail(request, meter_id):  # get /meters/<id>/ детальная страница счетчика
    # детали любого счетчика (получение счетчика по id)
    meter = get_object_or_404(WaterMeter, id=meter_id, is_active=True)
    return render(request, "meters/meter_detail.html", {"meter": meter})


def request_list(request):

    current_user = get_current_user()

    requests_list = (
        Request.objects.filter(user=current_user).exclude(status="deleted").order_by("-created_at")
    )

    for req in requests_list:
        req.positions_count = ReadingPosition.objects.filter(request=req).count()

    return render(request, "meters/request_list.html", {"requests": requests_list})


def request_detail(request, request_id):
    # внутренняя страница заявки
    current_user = get_current_user()
    request_obj = get_object_or_404(Request, id=request_id, user=current_user)

    if request_obj.status == "deleted":
        return redirect("request_list")

    positions = ReadingPosition.objects.filter(request=request_obj).select_related("water_meter")

    total_consumption = sum(p.consumption for p in positions)
    amount_to_pay = total_consumption * 50

    context = {
        "request_obj": request_obj,
        "positions": positions,
        "total_consumption": total_consumption,
        "amount_to_pay": amount_to_pay,
    }
    return render(request, "meters/request_detail.html", context)


def add_reading(request):  # post /add-reading/ добавление показаний
    # добавление показаний в черновик
    if request.method == "POST":
        current_user = get_current_user()
        meter_id = request.POST.get("meter_id")
        current_reading = request.POST.get("current_reading")

        # получение счетчик (без проверки пользователя)
        meter = get_object_or_404(WaterMeter, id=meter_id)

        draft_request = Request.objects.filter(status="draft", user=current_user).first()
        if not draft_request:
            draft_request = Request.objects.create(status="draft", user=current_user)

        existing_position = ReadingPosition.objects.filter(
            request=draft_request, water_meter=meter
        ).first()

        consumption = int(current_reading) - meter.last_verified_reading

        if existing_position:
            existing_position.current_reading = current_reading
            existing_position.consumption = consumption
            existing_position.save()
        else:
            ReadingPosition.objects.create(
                request=draft_request,
                water_meter=meter,
                current_reading=current_reading,
                consumption=consumption,
            )

        return redirect("request_detail", request_id=draft_request.id)

    return redirect("meter_list")


def submit_request(request, request_id):
    # отправка заявки на проверку
    current_user = get_current_user()
    request_obj = get_object_or_404(Request, id=request_id, user=current_user)

    if request_obj.status == "draft":
        request_obj.status = "submitted"
        request_obj.submitted_at = timezone.now()
        request_obj.save()

    return redirect("request_detail", request_id=request_id)


def delete_request(request, request_id):
    # удаление заявки через SQL UPDATE
    if request.method == "POST":
        current_user = get_current_user()
        with connection.cursor() as cursor:
            cursor.execute(
                "UPDATE requests SET status = 'deleted' WHERE id = %s AND user_id = %s",
                [request_id, current_user.id],
            )
        return redirect("request_list")
    return redirect("request_list")
