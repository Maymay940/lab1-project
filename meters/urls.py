from django.urls import path

from . import views

urlpatterns = [
    path("", views.meter_list, name="meter_list"),  # главная
    path("meters/<int:meter_id>/", views.meter_detail, name="meter_detail"),  # счетчики
    path("requests/", views.request_list, name="request_list"),  # заявки
    path(
        "requests/<int:request_id>/", views.request_detail, name="request_detail"
    ),  # заявки(переход внутрь)
    # действия
    path("add-reading/", views.add_reading, name="add_reading"),  # добавить показания в БД
    path(
        "submit-request/<int:request_id>/", views.submit_request, name="submit_request"
    ),  # статус отравлено
    path(
        "delete-request/<int:request_id>/", views.delete_request, name="delete_request"
    ),  # статус удалено
]
