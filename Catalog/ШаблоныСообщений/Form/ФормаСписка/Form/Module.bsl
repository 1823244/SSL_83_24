﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьОтборы();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		ВключенаОтправкаSMS = Истина;
		ВключенаРаботаСПочтовымиСообщениями = Истина;
	Иначе
		ВключенаРаботаСПочтовымиСообщениями = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями");
		ВключенаОтправкаSMS = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS");
	КонецЕсли;
	
	// кнопки в группе, если одна кнопка, то группа не нужна
	Элементы.ФормаСоздатьШаблонСообщенияSMS.Видимость = ВключенаОтправкаSMS;
	Элементы.ФормаСоздатьШаблонЭлектронногоПисьма.Видимость = ВключенаРаботаСПочтовымиСообщениями;
	
	Элементы.ФормаПоказыватьКонтекстныеШаблоны.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьОтборы()
	
	Элементы.НазначениеФильтр.СписокВыбора.Очистить();
	Элементы.ШаблонДляФильтр.СписокВыбора.Очистить();
	
	Список.Параметры.УстановитьЗначениеПараметра("Назначение", "");
	
	ВидыШаблонов = ШаблоныСообщенийСлужебный.ВидыШаблонов();
	ВидыШаблонов.Вставить(0, НСтр("ru = 'Электронных писем и SMS'"), НСтр("ru = 'Электронных писем и SMS'"));
	
	Список.Параметры.УстановитьЗначениеПараметра("СообщениеSMS", ВидыШаблонов.НайтиПоЗначению("SMS").Представление);
	Список.Параметры.УстановитьЗначениеПараметра("ЭлектроннаяПочта", ВидыШаблонов.НайтиПоЗначению("Email").Представление);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьКонтекстныеШаблоны", Ложь);
	
	Для каждого ВидШаблона Из ВидыШаблонов Цикл
		Элементы.ШаблонДляФильтр.СписокВыбора.Добавить(ВидШаблона.Значение, ВидШаблона.Представление);
	КонецЦикла;
	
	Элементы.НазначениеФильтр.СписокВыбора.Добавить("", НСтр("ru = 'Все'"));
	
	ОбщийПредставление = НСтр("ru = 'Общий'");
	Список.Параметры.УстановитьЗначениеПараметра("Общий", ОбщийПредставление);
	Элементы.НазначениеФильтр.СписокВыбора.Добавить("Общий", ОбщийПредставление);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ШаблоныСообщений.Назначение КАК Назначение
		|ИЗ
		|	Справочник.ШаблоныСообщений КАК ШаблоныСообщений
		|ГДЕ
		|	ШаблоныСообщений.Назначение <> """" И ШаблоныСообщений.Назначение <> ""Служебный""
		|
		|СГРУППИРОВАТЬ ПО
		|	ШаблоныСообщений.Назначение
		|
		|УПОРЯДОЧИТЬ ПО
		|	Назначение";
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		Элементы.НазначениеФильтр.СписокВыбора.Добавить(РезультатЗапроса.Назначение, РезультатЗапроса.Назначение);
	КонецЦикла;
	
	Назначение = "";
	ШаблонДля = НСтр("ru = 'Электронных писем и SMS'");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПослеЗаписиШаблонаСообщения" Тогда
		ИнициализироватьОтборы();
		УстановитьФильтрНазначение(Назначение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НазначениеФильтрПриИзменении(Элемент)
	УстановитьФильтрНазначение(Назначение);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФильтрНазначение(Знач ВыбранноеЗначение)
	
	Если ПустаяСтрока(ВыбранноеЗначение) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Назначение");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Назначение", ВыбранноеЗначение, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ШаблонДляФильтрОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение = "SMS" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ШаблонДля", НСтр("ru = 'Сообщения SMS'"), ВидСравненияКомпоновкиДанных.Равно);
	ИначеЕсли ВыбранноеЗначение = "Email" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ШаблонДля", НСтр("ru = 'Электронного письма'"), ВидСравненияКомпоновкиДанных.Равно);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ШаблонДля");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьШаблонЭлектронногоПисьма(Команда)
	ПараметрыФормы = Новый Структура("ВидСообщения", "ЭлектронноеПисьмо");
	ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы ,ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьШаблонСообщенияSMS(Команда)
	ПараметрыФормы = Новый Структура("ВидСообщения", "СообщениеSMS");
	ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы ,ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьКонтекстныеШаблоны(Команда)
	Элементы.ФормаПоказыватьКонтекстныеШаблоны.Пометка = Не Элементы.ФормаПоказыватьКонтекстныеШаблоны.Пометка;
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьКонтекстныеШаблоны", Элементы.ФормаПоказыватьКонтекстныеШаблоны.Пометка);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка.ВладелецШаблона");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти
