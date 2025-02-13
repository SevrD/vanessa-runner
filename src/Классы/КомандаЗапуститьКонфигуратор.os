///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Выполнение команды/действия в Конфигураторе автоматически или интерактивно
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

Перем Лог;

#КонецОбласти

#Область ОбработчикиСобытий

// Регистрация команды и ее аргументов/ключей
//
// Параметры:
//   ИмяКоманды - Строка - имя команды
//   Парсер - Парсер - объект парсера
//
Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания =
		"     Запуск Конфигуратора 1С - интерактивно или автоматически.
		|";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды,
		ТекстОписания);

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--no-wait",
		"Не ожидать завершения запущенной команды/действия");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-name", "Строка подключения к хранилищу");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-user", "Пользователь хранилища");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-pwd", "Пароль");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--ibsrv",
		"Запуск команды с использованием утилиты ibsrv");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ОбщиеМетоды.ЛогКоманды(ДополнительныеПараметры);

	ПараметрыАвтономногоСервера = ОбщиеМетоды.НовыеПараметрыАвтономногоСервера();
	ПараметрыАвтономногоСервера.ИспользоватьПрямоеСоединение = Истина;

	Действие = Новый Действие(ЭтотОбъект, "ЗапуститьКонфигуратор");
	Возврат ОбщиеМетоды.ВыполнитьКомандуСУчетомIbsrv(ПараметрыКоманды, Действие, ПараметрыАвтономногоСервера);

КонецФункции // ВыполнитьКоманду

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция  ЗапуститьКонфигуратор(ПараметрыКоманды) Экспорт

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	ПараметрыХранилища = Новый Структура;
	ПараметрыХранилища.Вставить("СтрокаПодключения", ПараметрыКоманды["--storage-name"]);
	ПараметрыХранилища.Вставить("Пользователь", ПараметрыКоманды["--storage-user"]);
	ПараметрыХранилища.Вставить("Пароль", ПараметрыКоманды["--storage-pwd"]);

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;

	ОжидатьЗавершения = Не ПараметрыКоманды["--no-wait"];

	МенеджерКонфигуратора.Конструктор(ДанныеПодключения, ПараметрыКоманды);

	МенеджерКонфигуратора.УстановитьПараметрыХранилища(ПараметрыХранилища);

	ДопСообщения = МенеджерКонфигуратора.НовыеДопСообщенияДляЗапускаПредприятия();
	ДопСообщения.Ключ = "ЗапускКонфигуратора";
	ДопСообщения.СообщениеВСлучаеУспеха = "Выполнение в режиме Конфигуратор 1С завершено";
	ДопСообщения.СообщениеВСлучаеПадения = "Возникла ошибка при выполнении в режиме Конфигуратор 1С!";
	ДопСообщения.СообщениеВСлучаеПропуска = "Возникла ошибка с кодом 2 при выполнении в режиме Конфигуратор 1С!!";

	Попытка
		МенеджерКонфигуратора.ЗапуститьКонфигуратор(
			ДопСообщения,
			ПараметрыКоманды["--additional"],
			ОжидатьЗавершения);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение;
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции

#КонецОбласти
