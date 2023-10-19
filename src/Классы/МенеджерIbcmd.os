
#Использовать ibcmdrunner
#Использовать v8find

#Область ОписаниеПеременных

Перем Лог; // Содердит объект ллога
Перем ВременныйКаталогДанныхСервера; // Временный каталог данных автономного сервера
Перем КаталогВременнойИБ;
Перем УправлениеИБ; // :УправлениеИБ
Перем Локаль; // Локаль приложения

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура УстановитьКонтекст(Знач СтрокаСоединения, Знач Пользователь, Знач Пароль) Экспорт
	
	КаталогБазы = ОбщиеМетоды.КаталогФайловойИБ(СтрокаСоединения);
	Лог.Отладка("Использовать каталог ИБ %1", КаталогБазы);
	УправлениеИБ.УстановитьПараметрыФайловойИБ(КаталогБазы);
	УправлениеИБ.УстановитьПараметрыАвторизацииИБ(Пользователь, Пароль);

КонецПроцедуры

Процедура СоздатьФайловуюБазу(Знач КаталогБазы, Знач ПутьКШаблону = "", Знач ИмяБазыВСписке = "") Экспорт

	ОбщиеМетоды.ОбеспечитьПустойКаталог(Новый Файл(КаталогБазы));

	УправлениеИБ.УстановитьПараметрыФайловойИБ(КаталогБазы);
	УправлениеИБ.СоздатьИБИзФайлаВыгрузки(ПутьКШаблону, ЛокальДляЗапуска());	

	СтрокаСоединения = СтрШаблон("File=""%1""", КаталогБазы);
	ДобавитьБазуВСписокБаз(ИмяБазыВСписке, СтрокаСоединения);

КонецПроцедуры

Процедура СобратьИзИсходниковТекущуюКонфигурацию(Знач ВходнойКаталог,
	Знач СписокФайловДляЗагрузки = "", СниматьСПоддержки = Ложь, ОбновитьФайлВерсий = Истина) Экспорт

	ИмяРасширения = "";

	Если СниматьСПоддержки Тогда
		УправлениеИБ.СнятьСПоддержки();
	КонецЕсли;

	Если ЗначениеЗаполнено(СписокФайловДляЗагрузки) Тогда
		УправлениеИБ.ЗагрузитьВыбранныеФайлыКонфигурации(ВходнойКаталог, СписокФайловДляЗагрузки, ИмяРасширения);
	Иначе
		УправлениеИБ.ЗагрузитьКонфигурациюИзФайлов(ВходнойКаталог, ИмяРасширения);
	КонецЕсли;

	Если ОбновитьФайлВерсий Тогда
		УправлениеИБ.ВыгрузитьВФайлСостояниеКонфигурации(ВходнойКаталог, ИмяРасширения);
	КонецЕсли;

КонецПроцедуры

Процедура ЗагрузитьИнфобазуИзФайла(Знач ПутьКЗагружаемомуФайлуСДанными, Знач КоличествоЗаданий = 0) Экспорт
	УправлениеИБ.ЗагрузитьДанныеИБ(ПутьКЗагружаемомуФайлуСДанными);
КонецПроцедуры

Процедура ЗагрузитьФайлКонфигурации(Знач ПутьКФайлу, Знач СниматьСПоддержки = Истина) Экспорт

	ИмяРасширения = "";
	УправлениеИБ.ЗагрузитьКонфигурацию(ПутьКФайлу, ИмяРасширения);

	Если СниматьСПоддержки Тогда
	 	УправлениеИБ.СнятьСПоддержки();
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьКонфигурациюБазыДанных(ДинамическоеОбновление = Ложь) Экспорт

	Если ДинамическоеОбновление Тогда
		РежимДинамическогоОбновления = "disable";
	Иначе
		РежимДинамическогоОбновления = "auto";
	КонецЕсли;
	ЗавершатьСеансы = "force";

	ИмяРасширения = "";
	УправлениеИБ.ОбновитьКонфигурациюБазыДанных(ИмяРасширения, РежимДинамическогоОбновления, ЗавершатьСеансы);

КонецПроцедуры

Процедура ВыгрузитьКонфигурациюВФайл(Знач ПутьКНужномуФайлуКонфигурации) Экспорт

	УправлениеИБ.ВыгрузитьКонфигурациюВФайл(ПутьКНужномуФайлуКонфигурации);

КонецПроцедуры

Процедура СобратьИзИсходниковРасширение(Каталог, ИмяРасширения, Обновить = Ложь) Экспорт

	УправлениеИБ.ЗагрузитьКонфигурациюИзФайлов(Каталог, ИмяРасширения);

	Если Обновить Тогда
		УправлениеИБ.ОбновитьКонфигурациюБазыДанных(ИмяРасширения);
	КонецЕсли;

КонецПроцедуры

// Выгружает файл расширения из ИБ
//
// Параметры:
//  ПутьКНужномуФайлуРасширения - Строка - Путь к результату - выгружаемому файлу конфигурации (*.cfe)
//  ИмяРасширения - Строка - Имя расширения
//
Процедура ВыгрузитьРасширениеВФайл(Знач ПутьКНужномуФайлуРасширения, Знач ИмяРасширения) Экспорт
	УправлениеИБ.ВыгрузитьКонфигурациюВФайл(ПутьКНужномуФайлуРасширения, ИмяРасширения);
КонецПроцедуры	

// Возвращает каталог времнной ИБ
//
//  Возвращаемое значение:
//   Строка - Каталог временной ИБ
//
Функция КаталогВременнойИБ() Экспорт
	Возврат КаталогВременнойИБ;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриСозданииОбъекта() 
	
	Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	ВременныйКаталогДанныхСервера = ВременныеФайлы.СоздатьКаталог();
	Локаль = "";
 
	УправлениеИБ = Новый УправлениеИБ;
	УправлениеИБ.УстановитьПараметрыАвтономногоСервера(ВременныйКаталогДанныхСервера);

КонецПроцедуры

Процедура Конструктор(Знач ДанныеПодключения, Знач ПараметрыКоманды) Экспорт

	ВерсияПлатформы = ДанныеПодключения.ВерсияПлатформы;
	Если ЗначениеЗаполнено(ВерсияПлатформы) Тогда
		Если ЗначениеЗаполнено(ДанныеПодключения.РазрядностьПлатформы) Тогда
			Разрядность = ОбщиеМетоды.РазрядностьПлатформы(ДанныеПодключения.РазрядностьПлатформы);
			Лог.Отладка("Разрядность платформы 1С указана %1", ДанныеПодключения.РазрядностьПлатформы);
		Иначе
			Разрядность = ОбщиеМетоды.РазрядностьПлатформы("x64x86");
			Лог.Отладка("Разрядность платформы 1С не указана");
		КонецЕсли;

		ПутьКIbcmd = ПутьКIbcmd(ВерсияПлатформы, Разрядность);
		УправлениеИБ.ПутьКПриложению(ПутьКIbcmd);
	КонецЕсли;
	Лог.Информация("Используется ibcmd платформы %1", ТекущаяВерсияПлатформы());

	ИспользоватьВременнуюБазу = ДанныеПодключения.ИспользоватьВременнуюБазу;
	Если ИспользоватьВременнуюБазу Тогда
		Лог.Отладка("ИспользоватьВременнуюБазу %1", ИспользоватьВременнуюБазу);
		
		КаталогВременнойИБ = ОбъединитьПути(ВременныйКаталогДанныхСервера, "db_data");

		СтрокаСоединения = СтрШаблон("/F%1", КаталогВременнойИБ);
		Пользователь = "";
		Пароль = "";

		УстановитьКонтекст(СтрокаСоединения, Пользователь, Пароль);
	 	
	Иначе
		УстановитьКонтекст(ДанныеПодключения.ПутьБазы, 
			ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль);
	КонецЕсли;

КонецПроцедуры

Процедура Деструктор() Экспорт
	
	Попытка
		ВременныеФайлы.УдалитьФайл(ВременныйКаталогДанныхСервера);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Лог.Отладка(КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;

	ВременныйКаталогДанныхСервера = "";

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПутьКIbcmd(ВерсияПлатформы, Разрядность)

	Если Не СтрНачинаетсяС(ВерсияПлатформы, "8.3") Тогда
		ВызватьИсключение "Неверная версия платформы <" + ВерсияПлатформы + ">";
	КонецЕсли;
	
	Возврат Платформа1С.ПутьКIBCMD(ВерсияПлатформы, Разрядность);

КонецФункции

Функция ЛокальДляЗапуска()
	
	Если ЗначениеЗаполнено(Локаль) Тогда
		Возврат Локаль;
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

Процедура ДобавитьБазуВСписокБаз(ИмяБазыВСписке, СтрокаСоединения)
	
	Если ПустаяСтрока(ИмяБазыВСписке) Тогда
		Возврат;
	КонецЕсли;

	КорневойПутьПроекта = ПараметрыСистемы.КорневойПутьПроекта;

	ДопДанныеСпискаБаз = Новый Структура;
	ДопДанныеСпискаБаз.Вставить("RootPath", КорневойПутьПроекта);
	ДопДанныеСпискаБаз.Вставить("Version", УправлениеИБ.Версия());

	ПолныйПуть = Новый Файл(КорневойПутьПроекта).ИмяБезРасширения;

	Попытка
		МенеджерСпискаБаз.ДобавитьБазуВСписокБаз(СтрокаСоединения, ПолныйПуть, ДопДанныеСпискаБаз);
	Исключение
		Лог.Предупреждение("Добавление базы в список " + ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры

Функция ТекущаяВерсияПлатформы()
	Возврат СокрЛП(УправлениеИБ.Версия());
КонецФункции

#КонецОбласти
