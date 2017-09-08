﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ВнутренниеДанные, СвойстваПароля;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СертификатПараметрыРеквизитов = Новый Структура;
	Если Параметры.Свойство("Организация") Тогда
		СертификатПараметрыРеквизитов.Вставить("Организация", Параметры.Организация);
	КонецЕсли;
	
	ОтборПоОрганизации = Параметры.ОтборПоОрганизации;
	
	Если Параметры.ДобавлениеВСписок Тогда
		ДобавлениеВСписок = Истина;
		Элементы.Выбрать.Заголовок = НСтр("ru = 'Добавить'");
		
		Элементы.ПояснениеУсиленногоПароля.Заголовок =
			НСтр("ru = 'Нажмите Добавить, чтобы перейти к вводу пароля.'");
		
		ЛичныйСписокПриДобавлении = Параметры.ЛичныйСписокПриДобавлении;
		Элементы.ПоказыватьВсе.Подсказка =
			НСтр("ru = 'Показать все сертификаты без отбора (например, включая добавленные и просроченные)'");
	КонецЕсли;
	
	ДляШифрованияИРасшифровки = Параметры.ДляШифрованияИРасшифровки;
	ВернутьПароль = Параметры.ВернутьПароль;
	
	Если ДляШифрованияИРасшифровки = Истина Тогда
		Если Параметры.ДобавлениеВСписок Тогда
			Заголовок = НСтр("ru = 'Добавление сертификата для шифрования и расшифровки данных'");
		Иначе
			Заголовок = НСтр("ru = 'Выбор сертификата для шифрования и расшифровки данных'");
		КонецЕсли;
	ИначеЕсли ДляШифрованияИРасшифровки = Ложь Тогда
		Если Параметры.ДобавлениеВСписок Тогда
			Заголовок = НСтр("ru = 'Добавление сертификата для подписания данных'");
		КонецЕсли;
	ИначеЕсли ЭлектроннаяПодпись.ИспользоватьШифрование() Тогда
		Заголовок = НСтр("ru = 'Добавление сертификата для подписания и шифрования данных'");
	Иначе
		Заголовок = НСтр("ru = 'Добавление сертификата для подписания данных'");
	КонецЕсли;
	
	ОбщиеНастройки = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки();
	СоздаватьЭлектронныеПодписиНаСервере = ОбщиеНастройки.СоздаватьЭлектронныеПодписиНаСервере;
	
	Если СоздаватьЭлектронныеПодписиНаСервере Тогда
		Элементы.ГруппаСертификаты.Заголовок =
			НСтр("ru = 'Личные сертификаты на компьютере и сервере'");
	КонецЕсли;
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	Элементы.СертификатОрганизация.Видимость = ЕстьОрганизации;
	
	Элементы.СертификатПользователь.Подсказка =
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Пользователь.Подсказка;
	
	Элементы.СертификатОрганизация.Подсказка =
		Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.Реквизиты.Организация.Подсказка;
	
	Если ЗначениеЗаполнено(Параметры.ОтпечатокВыбранногоСертификата) Тогда
		ОтпечатокВыбранногоСертификатаНеНайден = Ложь;
		ОтпечатокВыбранногоСертификата = Параметры.ОтпечатокВыбранногоСертификата;
	Иначе
		ОтпечатокВыбранногоСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Параметры.ВыбранныйСертификат, "Отпечаток");
	КонецЕсли;
	
	ОшибкаПолученияСертификатовНаКлиенте = Параметры.ОшибкаПолученияСертификатовНаКлиенте;
	ОбновитьСписокСертификатовНаСервере(Параметры.СвойстваСертификатовНаКлиенте);
	
	Если ЗначениеЗаполнено(Параметры.ОтпечатокВыбранногоСертификата)
	   И Параметры.ОтпечатокВыбранногоСертификата <> ОтпечатокВыбранногоСертификата Тогда
		
		ОтпечатокВыбранногоСертификатаНеНайден = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВнутренниеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ПрограммыЭлектроннойПодписиИШифрования")
	 Или ВРег(ИмяСобытия) = ВРег("Запись_ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux") Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Установка_РасширениеРаботыСКриптографией") Тогда
		ОбновитьСписокСертификатов();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности наименования.
	ЭлектроннаяПодписьСлужебный.ПроверитьУникальностьПредставления(
		СертификатНаименование, Сертификат, "СертификатНаименование", Отказ);
		
	// Проверка заполнения организации.
	Если Элементы.СертификатОрганизация.Видимость
	   И Не Элементы.СертификатОрганизация.ТолькоПросмотр
	   И Элементы.СертификатОрганизация.АвтоОтметкаНезаполненного = Истина
	   И Не ЗначениеЗаполнено(СертификатОрганизация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле Организация не заполнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "СертификатОрганизация",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатыНедоступныНаКлиентеНадписьНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Сертификаты на компьютере'"), "", ОшибкаПолученияСертификатовНаКлиенте, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНедоступныНаСервереНадписьНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Сертификаты на сервере'"), "", ОшибкаПолученияСертификатовНаСервере, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВсеПриИзменении(Элемент)
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОткрытьИнструкциюПоРаботеСПрограммами();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатУсиленнаяЗащитаЗакрытогоКлючаПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииСвойствСертификата", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаПароль", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаЗапомнитьПароль", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеУстановленногоПароляНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПояснениеУстановленногоПароляНажатие(ЭтотОбъект, Элемент, СвойстваПароля);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеУстановленногоПароляРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПояснениеУстановленногоПароляОбработкаНавигационнойСсылки(
		ЭтотОбъект, Элемент, НавигационнаяСсылка, СтандартнаяОбработка, СвойстваПароля);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Далее(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		ОтпечатокВыбранногоСертификата = "";
	Иначе
		ОтпечатокВыбранногоСертификата = Элементы.Сертификаты.ТекущиеДанные.Отпечаток;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеТекущегоСертификата(Команда)
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ОткрытьСертификат(ТекущиеДанные.Отпечаток, Не ТекущиеДанные.ЭтоЗаявление);
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Элементы.Далее.Доступность = Ложь;
	
	ПерейтиКВыборуТекущегоСертификата(Новый ОписаниеОповещения(
		"ДалееПослеПереходаКВыборуТекущегоСертификата", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеПереходаКВыборуТекущегоСертификата(Результат, Контекст) Экспорт
	
	Если Результат = Истина Тогда
		Элементы.Далее.Доступность = Истина;
		Возврат;
	КонецЕсли;
	
	Контекст = Результат;
	
	Если Контекст.ОбновитьСписокСертификатов Тогда
		ОбновитьСписокСертификатов(Новый ОписаниеОповещения(
			"ДалееПослеОбновленияСпискаСертификатов", ЭтотОбъект, Контекст));
	Иначе
		ДалееПослеОбновленияСпискаСертификатов(, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Далее.
&НаКлиенте
Процедура ДалееПослеОбновленияСпискаСертификатов(Результат, Контекст) Экспорт
	
	ПоказатьПредупреждение(, Контекст.ОписаниеОшибки);
	Элементы.Далее.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГлавныеСтраницы.ТекущаяСтраница = Элементы.СтраницаВыборСертификата;
	Элементы.Далее.КнопкаПоУмолчанию = Истина;
	
	ОбновитьСписокСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОшибкаНаСервере", Новый Структура);
	Контекст.Вставить("ОшибкаНаКлиенте", Новый Структура);
	
	СертификатЗаписан = Ложь;
	
	Если СертификатНаСервере
	   И ПроверитьСертификатИЗаписатьВСправочник(СвойстваПароля.Значение, Контекст.ОшибкаНаСервере) Тогда
		
		ВыбратьПослеПроверкиСертификата(Контекст.ОшибкаНаКлиенте, Контекст);
	Иначе
		Если СертификатВОблачномСервисе Тогда
			Оповещение = Новый ОписаниеОповещения("ВыбратьПослеПроверкиСертификатаВМоделиСервиса", ЭтотОбъект, Контекст);
		Иначе
			Оповещение = Новый ОписаниеОповещения("ВыбратьПослеПроверкиСертификата", ЭтотОбъект, Контекст);
		КонецЕсли;
		ПроверитьСертификат(Оповещение);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры Выбрать.
&НаКлиенте
Процедура ВыбратьПослеПроверкиСертификата(Результат, Контекст) Экспорт
	
	Если Результат.Свойство("Программа") Тогда
		ЗаписатьСертификатВСправочник(Результат.Программа);
	КонецЕсли;
	
	Если Результат.Свойство("ОписаниеОшибки") Тогда
		ОшибкаНаКлиенте = Результат;
		
		Если ДляШифрованияИРасшифровки = Истина Тогда
			ЗаголовокФормы = НСтр("ru = 'Проверка шифрования и расшифровки'");
		Иначе
			ЗаголовокФормы = НСтр("ru = 'Проверка установки электронной подписи'");
		КонецЕсли;
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
			ЗаголовокФормы, "", ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриУспешномВыполненииОперации", Истина));
	
	ОповеститьОбИзменении(Сертификат);
	
	Если ВернутьПароль Тогда
		ВнутренниеДанные.Вставить("ВыбранныйСертификат", Сертификат);
		Если Не ЗапомнитьПароль Тогда
			ВнутренниеДанные.Вставить("ВыбранныйСертификатПароль", СвойстваПароля.Значение);
		КонецЕсли;
		ОповеститьОВыборе(Истина);
	Иначе
		ОповеститьОВыборе(Сертификат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПослеПроверкиСертификатаВМоделиСервиса(Результат, Контекст) Экспорт
	
	Если Результат.Свойство("Действителен") И Результат.Действителен Тогда
		ЗаписатьСертификатВСправочникВМоделиСервиса();
	КонецЕсли;
	
	Если Результат.Свойство("ИнформацияОбОшибке") Тогда
		ОшибкаНаКлиенте = Результат.ИнформацияОбОшибке.Описание;
		
		Если ДляШифрованияИРасшифровки = Истина Тогда
			ЗаголовокФормы = НСтр("ru = 'Проверка шифрования и расшифровки'");
		Иначе
			ЗаголовокФормы = НСтр("ru = 'Проверка установки электронной подписи'");
		КонецЕсли;
		ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
			ЗаголовокФормы, "", ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		Возврат;
	КонецЕсли;
	
	ОповеститьОбИзменении(Сертификат);
	
	ОповеститьОВыборе(Сертификат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	Если ЗначениеЗаполнено(СертификатАдрес) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатАдрес, Истина);
	Иначе
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(СертификатОтпечаток, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПродолжитьОткрытие(Оповещение, ОбщиеВнутренниеДанные) Экспорт
	
	ВнутренниеДанные = ОбщиеВнутренниеДанные;
	ОбработкаПродолжения = Новый ОписаниеОповещения("ПродолжитьОткрытие", ЭтотОбъект);
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные, СвойстваПароля);
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	Если ОтпечатокВыбранногоСертификатаНеНайден = Неопределено
	 Или ОтпечатокВыбранногоСертификатаНеНайден = Истина Тогда
		
		ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата(, Контекст);
	Иначе
		ПерейтиКВыборуТекущегоСертификата(Новый ОписаниеОповещения(
			"ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата", ЭтотОбъект, Контекст));
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеПереходаКВыборуТекущегоСертификата(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ОповеститьОВыборе(Ложь);
	Иначе
		Открыть();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСвойстваТекущегоСертификатаНаСервере(Знач Отпечаток, СохраненныеСвойства);
	
	СертификатКриптографии = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(Отпечаток, Ложь);
	Если СертификатКриптографии = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СертификатАдрес = ПоместитьВоВременноеХранилище(СертификатКриптографии.Выгрузить(),
		УникальныйИдентификатор);
	
	СертификатОтпечаток = Отпечаток;
	
	ЭлектроннаяПодписьКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(СертификатОписаниеДанных,
		СертификатКриптографии);
	
	СохраненныеСвойства = СохраненныеСвойстваСертификата(Отпечаток,
		СертификатАдрес, СертификатПараметрыРеквизитов);
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция СохраненныеСвойстваСертификата(Знач Отпечаток, Знач Адрес, ПараметрыРеквизитов)
	
	Возврат ЭлектроннаяПодписьСлужебный.СохраненныеСвойстваСертификата(Отпечаток, Адрес, ПараметрыРеквизитов);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокСертификатов(Оповещение = Неопределено)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСвойстваСертификатовНаКлиенте(Новый ОписаниеОповещения(
		"ОбновитьСписокСертификатовПродолжение", ЭтотОбъект, Контекст), Истина, ПоказыватьВсе);
	
КонецПроцедуры

// Продолжение процедуры ОбновитьСписокСертификатов.
&НаКлиенте
Процедура ОбновитьСписокСертификатовПродолжение(Результат, Контекст) Экспорт
	
	ОшибкаПолученияСертификатовНаКлиенте = Результат.ОшибкаПолученияСертификатовНаКлиенте;
	
	ОбновитьСписокСертификатовНаСервере(Результат.СвойстваСертификатовНаКлиенте);
	
	Если Контекст.Оповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСертификатовНаСервере(Знач СвойстваСертификатовНаКлиенте)
	
	ОшибкаПолученияСертификатовНаСервере = Новый Структура;
	
	ЭлектроннаяПодписьСлужебный.ОбновитьСписокСертификатов(Сертификаты, СвойстваСертификатовНаКлиенте,
		ДобавлениеВСписок, Истина, ОшибкаПолученияСертификатовНаСервере, ПоказыватьВсе, ОтборПоОрганизации);
	
	Если ЗначениеЗаполнено(ОтпечатокВыбранногоСертификата)
	   И (    Элементы.Сертификаты.ТекущаяСтрока = Неопределено
	      Или Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока) = Неопределено
	      Или Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока).Отпечаток
	              <> ОтпечатокВыбранногоСертификата) Тогда
		
		Отбор = Новый Структура("Отпечаток", ОтпечатокВыбранногоСертификата);
		Строки = Сертификаты.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			Элементы.Сертификаты.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаСертификатыНедоступныНаКлиенте.Видимость =
		ЗначениеЗаполнено(ОшибкаПолученияСертификатовНаКлиенте);
	
	Элементы.ГруппаСертификатыНедоступныНаСервере.Видимость =
		ЗначениеЗаполнено(ОшибкаПолученияСертификатовНаСервере);
	
	Если Элементы.Сертификаты.ТекущаяСтрока = Неопределено Тогда
		ОтпечатокВыбранногоСертификата = "";
	Иначе
		Строка = Сертификаты.НайтиПоИдентификатору(Элементы.Сертификаты.ТекущаяСтрока);
		ОтпечатокВыбранногоСертификата = ?(Строка = Неопределено, "", Строка.Отпечаток);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификата(Оповещение)
	
	Результат = Новый Структура;
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ОбновитьСписокСертификатов", Ложь);
	
	Если Элементы.Сертификаты.ТекущиеДанные = Неопределено Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Выделите сертификат, который будет использоваться.'");
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	
	Если ТекущиеДанные.ЭтоЗаявление Тогда
		Результат.ОбновитьСписокСертификатов = Истина;
		Результат.ОписаниеОшибки =
			НСтр("ru = 'Для этого сертификата заявление на выпуск еще не исполнено.
			           |Откройте заявление на выпуск сертификата и выполните требуемые шаги.'");
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
		Возврат;
	КонецЕсли;
	
	СертификатНаКлиенте = ТекущиеДанные.НаКлиенте;
	СертификатНаСервере = ТекущиеДанные.НаСервере;
	СертификатВОблачномСервисе = ТекущиеДанные.ВОблачномСервисе;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение",          Оповещение);
	Контекст.Вставить("Результат",           Результат);
	Контекст.Вставить("ТекущиеДанные",       ТекущиеДанные);
	Контекст.Вставить("СохраненныеСвойства", Неопределено);
	
	Если СертификатНаСервере Тогда
		Если ЗаполнитьСвойстваТекущегоСертификатаНаСервере(ТекущиеДанные.Отпечаток, Контекст.СохраненныеСвойства) Тогда
			ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст);
		Иначе
			Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат не найден на сервере (возможно удален).'");
			Результат.ОбновитьСписокСертификатов = Истина;
			ВыполнитьОбработкуОповещения(Оповещение, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ВОблачномСервисе Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Отпечаток", Base64Значение(ТекущиеДанные.Отпечаток));
		МодульХранилищеСертификатовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ХранилищеСертификатовКлиент");
		МодульХранилищеСертификатовКлиент.НайтиСертификат(Новый ОписаниеОповещения(
			"ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификатаВОблачномСервисе", ЭтотОбъект, Контекст), СтруктураПоиска);
	Иначе
		// СертификатНаКлиенте.
		ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСертификатПоОтпечатку(
			Новый ОписаниеОповещения("ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификата", ЭтотОбъект, Контекст),
			ТекущиеДанные.Отпечаток, Ложь, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификата(РезультатПоиска, Контекст) Экспорт
	
	Если ТипЗнч(РезультатПоиска) <> Тип("СертификатКриптографии") Тогда
		Если РезультатПоиска.Свойство("СертификатНеНайден") Тогда
			Контекст.Результат.ОписаниеОшибки = НСтр("ru = 'Сертификат не найден на компьютере (возможно удален).'");
		Иначе
			Контекст.Результат.ОписаниеОшибки = РезультатПоиска.ОписаниеОшибки;
		КонецЕсли;
		Контекст.Результат.ОбновитьСписокСертификатов = Истина;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.Результат);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("СертификатКриптографии", РезультатПоиска);
	
	Контекст.СертификатКриптографии.НачатьВыгрузку(Новый ОписаниеОповещения(
		"ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеПоискаСертификатаВОблачномСервисе(РезультатПоиска, Контекст) Экспорт
	
	Если Не РезультатПоиска.Выполнено Тогда
		Контекст.Вставить("ОписаниеОшибки", РезультатПоиска.ОписаниеОшибки.Описание);
	КонецЕсли;
	
	Контекст.Вставить("СертификатКриптографии", РезультатПоиска.Сертификат);
	
	ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата(РезультатПоиска.Сертификат.Сертификат, Контекст);
	
КонецПроцедуры
// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеВыгрузкиСертификата(ВыгруженныеДанные, Контекст) Экспорт
	
	СертификатАдрес = ПоместитьВоВременноеХранилище(ВыгруженныеДанные, УникальныйИдентификатор);
	
	СертификатОтпечаток = Контекст.ТекущиеДанные.Отпечаток;
	
	ЭлектроннаяПодписьКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(СертификатОписаниеДанных,
		Контекст.СертификатКриптографии);
	
	Контекст.СохраненныеСвойства = СохраненныеСвойстваСертификата(Контекст.ТекущиеДанные.Отпечаток,
		СертификатАдрес, СертификатПараметрыРеквизитов);
		
	Если ЗначениеЗаполнено(ОтборПоОрганизации) Тогда
		Контекст.СохраненныеСвойства.Вставить("Организация", ОтборПоОрганизации);
	КонецЕсли;
	
	ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПерейтиКВыборуТекущегоСертификата.
&НаКлиенте
Процедура ПерейтиКВыборуТекущегоСертификатаПослеЗаполненияСвойствСертификата(Контекст)
	
	Если СертификатПараметрыРеквизитов.Свойство("Наименование") Тогда
		Если СертификатПараметрыРеквизитов.Наименование.ТолькоПросмотр Тогда
			Элементы.СертификатНаименование.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьОрганизации Тогда
		Если СертификатПараметрыРеквизитов.Свойство("Организация") Тогда
			Если Не СертификатПараметрыРеквизитов.Организация.Видимость Тогда
				Элементы.СертификатОрганизация.Видимость = Ложь;
			ИначеЕсли СертификатПараметрыРеквизитов.Организация.ТолькоПросмотр Тогда
				Элементы.СертификатОрганизация.ТолькоПросмотр = Истина;
			ИначеЕсли СертификатПараметрыРеквизитов.Организация.ПроверкаЗаполнения Тогда
				Элементы.СертификатОрганизация.АвтоОтметкаНезаполненного = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если СертификатПараметрыРеквизитов.Свойство("УсиленнаяЗащитаЗакрытогоКлюча") Тогда
		Если Не СертификатПараметрыРеквизитов.УсиленнаяЗащитаЗакрытогоКлюча.Видимость Тогда
			Элементы.СертификатУсиленнаяЗащитаЗакрытогоКлюча.Видимость = Ложь;
		ИначеЕсли СертификатПараметрыРеквизитов.УсиленнаяЗащитаЗакрытогоКлюча.ТолькоПросмотр Тогда
			Элементы.СертификатУсиленнаяЗащитаЗакрытогоКлюча.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Сертификат             = Контекст.СохраненныеСвойства.Ссылка;
	СертификатПользователь = Контекст.СохраненныеСвойства.Пользователь;
	СертификатОрганизация  = Контекст.СохраненныеСвойства.Организация;
	СертификатНаименование = Контекст.СохраненныеСвойства.Наименование;
	СертификатУсиленнаяЗащитаЗакрытогоКлюча = Контекст.СохраненныеСвойства.УсиленнаяЗащитаЗакрытогоКлюча;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект, ВнутренниеДанные, СвойстваПароля);
	
	Элементы.ГлавныеСтраницы.ТекущаяСтраница = Элементы.СтраницаУточнениеСвойствСертификата;
	Элементы.Выбрать.КнопкаПоУмолчанию = Истина;
	
	Если ДобавлениеВСписок Тогда
		Строка = ?(ЗначениеЗаполнено(Сертификат), НСтр("ru = 'Обновить'"), НСтр("ru = 'Добавить'"));
		Если Элементы.Выбрать.Заголовок <> Строка Тогда
			Элементы.Выбрать.Заголовок = Строка;
		КонецЕсли;
	КонецЕсли;
	
	Если СертификатВОблачномСервисе Тогда
		Элементы.ГруппаУсиленнаяЗащитаЗакрытогоКлюча.Видимость = Ложь;
	Иначе
		Элементы.ГруппаУсиленнаяЗащитаЗакрытогоКлюча.Видимость = Истина;
		ПодключитьОбработчикОжидания("ОбработчикОжиданияАктивизироватьЭлементПароль", 0.1, Истина);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияАктивизироватьЭлементПароль()
	
	ТекущийЭлемент = Элементы.Пароль;
	
КонецПроцедуры


&НаКлиенте
Процедура ПроверитьСертификат(Оповещение)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	
	Если СертификатВОблачномСервисе Тогда
		МодульСервисКриптографииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииКлиент");
		МодульСервисКриптографииКлиент.ПроверитьСертификат(Оповещение, ПолучитьИзВременногоХранилища(СертификатАдрес));
	Иначе
	     ЭлектроннаяПодписьСлужебныйКлиент.СоздатьМенеджерКриптографии(Новый ОписаниеОповещения(
			"ПроверитьСертификатПослеСозданияМенеджераКриптографии", ЭтотОбъект, Контекст), "", Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатПослеСозданияМенеджераКриптографии(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("МенеджерКриптографии")
		И Результат.Общая Тогда
		
		Если ДляШифрованияИРасшифровки = Истина Тогда
			Результат.Вставить("ЗаголовокОшибки", НСтр("ru = 'Не удалось пройти проверку шифрования по причине:'"));
		Иначе
			Результат.Вставить("ЗаголовокОшибки", НСтр("ru = 'Не удалось пройти проверку подписания по причине:'"));
		КонецЕсли;
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("ДвоичныеДанныеСертификата", ПолучитьИзВременногоХранилища(СертификатАдрес));
	
	СертификатКриптографии = Новый СертификатКриптографии;
	СертификатКриптографии.НачатьИнициализацию(Новый ОписаниеОповещения(
			"ПроверитьСертификатПослеИнициализацииСертификата", ЭтотОбъект, Контекст),
		Контекст.ДвоичныеДанныеСертификата);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатПослеИнициализацииСертификата(СертификатКриптографии, Контекст) Экспорт
	
	Контекст.Вставить("СертификатКриптографии", СертификатКриптографии);
	
	Контекст.Вставить("ОписаниеОшибки", "");
	Контекст.Вставить("ОшибкаНаКлиенте", Новый Структура);
	
	Контекст.ОшибкаНаКлиенте.Вставить("ОписаниеОшибки", "");
	Контекст.ОшибкаНаКлиенте.Вставить("Ошибки", Новый Массив);
	
	Контекст.Вставить("ОписанияПрограмм", ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ОписанияПрограмм);
	Контекст.Вставить("Индекс", -1);
	
	ПроверитьСертификатЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатЦиклНачало(Контекст)
	
	Если Контекст.ОписанияПрограмм.Количество() <= Контекст.Индекс + 1 Тогда
		Контекст.ОшибкаНаКлиенте.Вставить("ОписаниеОшибки", СокрЛП(Контекст.ОписаниеОшибки));
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Контекст.ОшибкаНаКлиенте);
		Возврат;
	КонецЕсли;
	Контекст.Индекс = Контекст.Индекс + 1;
	Контекст.Вставить("ОписаниеПрограммы", Контекст.ОписанияПрограмм[Контекст.Индекс]);
	
	ЭлектроннаяПодписьСлужебныйКлиент.СоздатьМенеджерКриптографии(Новый ОписаниеОповещения(
			"ПроверитьСертификатЦиклПослеСозданияМенеджераКриптографии", ЭтотОбъект, Контекст),
		"", Неопределено, Контекст.ОписаниеПрограммы.Ссылка);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатЦиклПослеСозданияМенеджераКриптографии(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("МенеджерКриптографии") Тогда
		Если Результат.Ошибки.Количество() > 0 Тогда
			Контекст.ОшибкаНаКлиенте.Ошибки.Добавить(Результат.Ошибки[0]);
		КонецЕсли;
		ПроверитьСертификатЦиклНачало(Контекст);
		Возврат;
	КонецЕсли;
	Контекст.Вставить("МенеджерКриптографии", Результат);
	
	Контекст.МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = СвойстваПароля.Значение;
	
	Если ДляШифрованияИРасшифровки = Истина Тогда
		Контекст.МенеджерКриптографии.НачатьШифрование(Новый ОписаниеОповещения(
				"ПроверитьСертификатЦиклПослеШифрования", ЭтотОбъект, Контекст,
				"ПроверитьСертификатЦиклПослеОшибкиШифрования", ЭтотОбъект),
			Контекст.ДвоичныеДанныеСертификата, Контекст.СертификатКриптографии);
	Иначе
		Контекст.МенеджерКриптографии.НачатьПодписывание(Новый ОписаниеОповещения(
				"ПроверитьСертификатЦиклПослеПодписания", ЭтотОбъект, Контекст,
				"ПроверитьСертификатЦиклПослеОшибкиПодписания", ЭтотОбъект),
			Контекст.ДвоичныеДанныеСертификата, Контекст.СертификатКриптографии);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатЦиклПослеОшибкиПодписания(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЗаполнитьОшибкуПодписания(Контекст.ОшибкаНаКлиенте, Контекст.ОписаниеОшибки, Контекст.ОписаниеПрограммы,
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке), Ложь);
	
	ПроверитьСертификатЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатЦиклПослеПодписания(ДанныеПодписи, Контекст) Экспорт
	
	ПредставлениеОшибки = "";
	Попытка
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеДанныеПодписи(ДанныеПодписи, ПредставлениеОшибки);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
		ЗаполнитьОшибкуПодписания(Контекст.ОшибкаНаКлиенте, Контекст.ОписаниеОшибки, Контекст.ОписаниеПрограммы,
			ПредставлениеОшибки, ИнформацияОбОшибке = Неопределено);
		ПроверитьСертификатЦиклНачало(Контекст);
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("Программа", Контекст.ОписаниеПрограммы.Ссылка);
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатЦиклПослеОшибкиШифрования(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЗаполнитьОшибкуШифрования(Контекст.ОшибкаНаКлиенте, Контекст.ОписаниеОшибки, Контекст.ОписаниеПрограммы,
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	ПроверитьСертификатЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатЦиклПослеШифрования(ЗашифрованныеДанные, Контекст) Экспорт
	
	Контекст.МенеджерКриптографии.НачатьРасшифровку(Новый ОписаниеОповещения(
			"ПроверитьСертификатЦиклПослеРасшифровки", ЭтотОбъект, Контекст,
			"ПроверитьСертификатЦиклПослеОшибкиРасшифровки", ЭтотОбъект),
		ЗашифрованныеДанные);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатЦиклПослеОшибкиРасшифровки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЗаполнитьОшибкуРасшифровки(Контекст.ОшибкаНаКлиенте, Контекст.ОписаниеОшибки, Контекст.ОписаниеПрограммы,
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	ПроверитьСертификатЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатЦиклПослеРасшифровки(РасшифрованныеДанные, Контекст) Экспорт
	
	ПредставлениеОшибки = "";
	Попытка
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеРасшифрованныеДанные(РасшифрованныеДанные, ПредставлениеОшибки);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
		ЗаполнитьОшибкуРасшифровки(Контекст.ОшибкаНаКлиенте, Контекст.ОписаниеОшибки, Контекст.ОписаниеПрограммы,
			ПредставлениеОшибки);
		ПроверитьСертификатЦиклНачало(Контекст);
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("Программа", Контекст.ОписаниеПрограммы.Ссылка);
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры


&НаСервере
Функция ПроверитьСертификатИЗаписатьВСправочник(Знач ЗначениеПароля, ОшибкаНаСервере)
	
	Если ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("", Ложь, ОшибкаНаСервере) = Неопределено
	   И ОшибкаНаСервере.Общая Тогда
		
		Если ДляШифрованияИРасшифровки = Истина Тогда
			ОшибкаНаСервере.Вставить("ЗаголовокОшибки", НСтр("ru = 'Не удалось пройти проверку шифрования по причине:'"));
		Иначе
			ОшибкаНаСервере.Вставить("ЗаголовокОшибки", НСтр("ru = 'Не удалось пройти проверку подписания по причине:'"));
		КонецЕсли;
		Возврат Ложь;
	КонецЕсли;
	
	ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(СертификатАдрес);
	СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
	
	ОшибкаНаСервере = Новый Структура;
	ОшибкаНаСервере.Вставить("ОписаниеОшибки", "");
	ОшибкаНаСервере.Вставить("Ошибки", Новый Массив);
	
	ОписаниеОшибки = "";
	
	ОписанияПрограмм = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ОписанияПрограмм;
	Для каждого ОписаниеПрограммы Из ОписанияПрограмм Цикл
		ОшибкаМенеджера = Новый Структура;
		
		МенеджерКриптографии = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("",
			Ложь, ОшибкаМенеджера, ОписаниеПрограммы.Ссылка);
		
		Если МенеджерКриптографии = Неопределено Тогда
			Если ОшибкаМенеджера.Ошибки.Количество() > 0 Тогда
				ОшибкаНаСервере.Ошибки.Добавить(ОшибкаМенеджера.Ошибки[0]);
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = ЗначениеПароля;
		
		Если ДляШифрованияИРасшифровки = Истина Тогда
			Успех = ПроверитьШифрованиеИРасшифровкуНаСервере(МенеджерКриптографии, ДвоичныеДанныеСертификата,
				СертификатКриптографии, ОписаниеПрограммы, ОшибкаНаСервере, ОписаниеОшибки);
		Иначе
			Успех = ПроверитьПодписаниеНаСервере(МенеджерКриптографии, ДвоичныеДанныеСертификата,
				СертификатКриптографии, ОписаниеПрограммы, ОшибкаНаСервере, ОписаниеОшибки);
		КонецЕсли;
		
		Если Успех Тогда
			ЗаписатьСертификатВСправочник(ОписаниеПрограммы.Ссылка);
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	ОшибкаНаСервере.Вставить("ОписаниеОшибки", СокрЛП(ОписаниеОшибки));
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ПроверитьШифрованиеИРасшифровкуНаСервере(МенеджерКриптографии, ДвоичныеДанныеСертификата,
			СертификатКриптографии, ОписаниеПрограммы, ОшибкаНаСервере, ОписаниеОшибки)
	
	ПредставлениеОшибки = "";
	Попытка
		ЗашифрованныеДанные = МенеджерКриптографии.Зашифровать(ДвоичныеДанныеСертификата, СертификатКриптографии);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
		ЗаполнитьОшибкуШифрования(ОшибкаНаСервере, ОписаниеОшибки, ОписаниеПрограммы, ПредставлениеОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	ПредставлениеОшибки = "";
	Попытка
		РасшифрованныеДанные = МенеджерКриптографии.Расшифровать(ЗашифрованныеДанные);
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеРасшифрованныеДанные(РасшифрованныеДанные, ПредставлениеОшибки);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
		ЗаполнитьОшибкуРасшифровки(ОшибкаНаСервере, ОписаниеОшибки, ОписаниеПрограммы, ПредставлениеОшибки);
		Возврат Ложь;
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПроверитьПодписаниеНаСервере(МенеджерКриптографии, ДвоичныеДанныеСертификата,
			СертификатКриптографии, ОписаниеПрограммы, ОшибкаНаСервере, ОписаниеОшибки)
	
	ПредставлениеОшибки = "";
	Попытка
		ДанныеПодписи = МенеджерКриптографии.Подписать(ДвоичныеДанныеСертификата, СертификатКриптографии);
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеДанныеПодписи(ДанныеПодписи, ПредставлениеОшибки);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	Если ЗначениеЗаполнено(ПредставлениеОшибки) Тогда
		ЗаполнитьОшибкуПодписания(ОшибкаНаСервере, ОписаниеОшибки, ОписаниеПрограммы,
			ПредставлениеОшибки, ИнформацияОбОшибке <> Неопределено);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗаписатьСертификатВСправочник(Программа)
	
	ЭлектроннаяПодписьСлужебный.ЗаписатьСертификатВСправочник(ЭтотОбъект, Программа);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьСертификатВСправочникВМоделиСервиса()
	
	ЭлектроннаяПодписьСлужебный.ЗаписатьСертификатВСправочник(ЭтотОбъект, , Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОшибкуШифрования(Ошибка, ОписаниеОшибки, ОписаниеПрограммы, ПредставлениеОшибки)
	
	ТекущаяОшибка = Новый Структура;
	ТекущаяОшибка.Вставить("Описание", ПредставлениеОшибки);
	ТекущаяОшибка.Вставить("Инструкция", Истина);
	ТекущаяОшибка.Вставить("НастройкаПрограмм", Истина);
	
	Ошибка.Ошибки.Добавить(ТекущаяОшибка);
	
	ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось пройти проверку шифрования с помощью программы %1 по причине:
		           |%2'"),
		ОписаниеПрограммы.Наименование,
		ПредставлениеОшибки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОшибкуРасшифровки(Ошибка, ОписаниеОшибки, ОписаниеПрограммы, ПредставлениеОшибки)
	
	ТекущаяОшибка = Новый Структура;
	ТекущаяОшибка.Вставить("Описание", ПредставлениеОшибки);
	ТекущаяОшибка.Вставить("Инструкция", Истина);
	ТекущаяОшибка.Вставить("НастройкаПрограмм", Истина);
	
	Ошибка.Ошибки.Добавить(ТекущаяОшибка);
	
	ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось пройти проверку расшифровки с помощью программы %1 по причине:
		           |%2'"),
		ОписаниеПрограммы.Наименование,
		ПредставлениеОшибки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОшибкуПодписания(Ошибка, ОписаниеОшибки, ОписаниеПрограммы, ПредставлениеОшибки, ПустыеДанные)
	
	ТекущаяОшибка = Новый Структура;
	ТекущаяОшибка.Вставить("Описание", ПредставлениеОшибки);
	
	Если Не ПустыеДанные Тогда
		ТекущаяОшибка.Вставить("НастройкаПрограмм", Истина);
		ТекущаяОшибка.Вставить("Инструкция", Истина);
	КонецЕсли;
	
	Ошибка.Ошибки.Добавить(ТекущаяОшибка);
	
	ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось пройти проверку подписания с помощью программы %1 по причине:
		           |%2'"),
		ОписаниеПрограммы.Наименование,
		ПредставлениеОшибки);
	
КонецПроцедуры

#КонецОбласти
