﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает XDTO тип - сообщение.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип сообщения.
//
Функция ТипСообщение() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетСообщения(), "Message");
	
КонецФункции

// Возвращает тип, являющийся базовым для всех типов тел сообщений
// в модели сервиса.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип тел сообщений в модели сервиса.
//
Функция ТипТело() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетСообщения(), "Body");
	
КонецФункции

// Возвращает тип, являющийся базовым для всех типов тел сообщений, 
// относящихся к областям данных в модели сервиса.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип тел сообщений областей данных в модели сервиса.
//
Функция ТипТелоОбласти() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетСообщения(), "ZoneBody");
	
КонецФункции

// Возвращает тип, являющийся базовым для всех типов тел сообщений, 
// отправляемых из областей данных с аутентификацией области в модели сервиса.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип тел сообщений областей данных с аутентификацией 
//   в модели сервиса.
//
Функция ТипАутентифицированноеТелоОбласти() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетСообщения(), "AuthenticatedZoneBody");
	
КонецФункции

// Возвращает тип - заголовок сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип заголовок сообщения в модели сервиса.
//
Функция ТипЗаголовокСообщения() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетСообщения(), "Header");
	
КонецФункции

// Возвращает тип - узел обмена сообщениями в модели сервиса.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип узел обмена сообщениями в модели сервиса.
//
Функция ТипУзелОбменаСообщениями() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетСообщения(), "Node");
	
КонецФункции

// Возвращает типы объектов XDTO содержащихся в заданном
// пакете, являющиеся типа сообщений удаленного администрирования.
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого
//   требуется получить.
//
// Возвращаемое значение:
//  ФиксированныйМассив(ТипОбъектаXDTO) - типы сообщений найденные в пакете.
//
Функция ПолучитьТипыСообщенийПакета(Знач URIПакета) Экспорт
	
	БазовыйТип = СообщенияВМоделиСервисаПовтИсп.ТипТело();
	Результат = ИнтерфейсыСообщенийВМоделиСервиса.ПолучитьТипыСообщенийПакета(URIПакета, БазовыйТип);
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Возвращает имена каналов сообщений из заданного пакета.
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого
//   требуется получить.
//
// Возвращаемое значение:
//  ФиксированныйМассив(Строка) - имена каналов найденные в пакете.
//
Функция ПолучитьКаналыПакета(Знач URIПакета) Экспорт
	
	Результат = Новый Массив;
	
	ТипыСообщенийПакета = 
		СообщенияВМоделиСервисаПовтИсп.ПолучитьТипыСообщенийПакета(URIПакета);
	
	Для каждого ТипСообщения Из ТипыСообщенийПакета Цикл
		Результат.Добавить(СообщенияВМоделиСервиса.ИмяКаналаПоТипуСообщения(ТипСообщения));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает uri пакета сообщений с базовыми типами.
//
// Возвращаемое значение:
//   Строка - пакет сообщений.
//
Функция ПакетСообщения()
	
	Возврат "http://www.1c.ru/SaaS/Messages";
	
КонецФункции

#КонецОбласти
