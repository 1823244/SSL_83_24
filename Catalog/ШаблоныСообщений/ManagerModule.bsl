﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	Если Параметры.Свойство("ВладелецШаблона") И ЗначениеЗаполнено(Параметры.ВладелецШаблона) Тогда
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			Параметры.Вставить("ВладелецШаблона", Параметры.ВладелецШаблона);
			Параметры.Вставить("Ключ", ОпределитьШаблонПоВладельцу(Параметры.ВладелецШаблона));
			ВыбраннаяФорма = "Справочник.ШаблоныСообщений.ФормаОбъекта";
			СтандартнаяОбработка = Ложь;
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Функция ОпределитьШаблонПоВладельцу(ВладелецШаблона)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШаблоныСообщений.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ШаблоныСообщений КАК ШаблоныСообщений
		|ГДЕ
		|	ШаблоныСообщений.ВладелецШаблона = &ВладелецШаблона";
	
	Запрос.УстановитьПараметр("ВладелецШаблона", ВладелецШаблона);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат РезультатЗапроса.Выгрузить()[0].Ссылка;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
