﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает основной производственный календарь, используемый в учете.
//
// Возвращаемое значение:
//   СправочникСсылка.ПроизводственныеКалендари, Неопределено - основной производственный календарь или 
//                                                              Неопределено, в случае если он не обнаружен.
//
Функция ОсновнойПроизводственныйКалендарь() Экспорт
		
	// Производственный календарь, составленный в соответствии с ст. 112 ТК РФ.
	ПроизводственныйКалендарь = Справочники.ПроизводственныеКалендари.НайтиПоКоду("РФ");
	Если ПроизводственныйКалендарь.Пустая() Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Возврат ПроизводственныйКалендарь;
	
КонецФункции

// Заполняет даты праздничных дней по производственному календарю для конкретного календарного года.
// 
// Параметры:
//   КодПроизводственногоКалендаря - Строка - код производственного календаря.
//   НомерГода                     - Число  - номер года, для которого требуется заполнить праздничные дни.
//   ПраздничныеДни                - ТаблицаЗначений - заполняет переданную таблицу с колонками:
//     * Дата               - Дата   - календарная дата праздничного дня.
//     * ПереноситьВыходной - Булево - Истина, если нужен перенос праздничного дня, если он приходится на выходной.
//
Процедура ЗаполнитьПраздничныеДни(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни) Экспорт
	
	Если КодПроизводственногоКалендаря = "РФ" Тогда
		
		// 1, 2, 3, 4, 5, 6 и 8 января - Новогодние каникулы.
		ДобавитьПраздничныйДень(ПраздничныеДни, "01.01", НомерГода, Ложь);
		ДобавитьПраздничныйДень(ПраздничныеДни, "02.01", НомерГода, Ложь);
		ДобавитьПраздничныйДень(ПраздничныеДни, "03.01", НомерГода, Ложь);
		ДобавитьПраздничныйДень(ПраздничныеДни, "04.01", НомерГода, Ложь);
		ДобавитьПраздничныйДень(ПраздничныеДни, "05.01", НомерГода, Ложь);
		ДобавитьПраздничныйДень(ПраздничныеДни, "06.01", НомерГода, Ложь);
		ДобавитьПраздничныйДень(ПраздничныеДни, "08.01", НомерГода, Ложь);
		
		// 7 января - Рождество Христово.
		ДобавитьПраздничныйДень(ПраздничныеДни, "07.01", НомерГода, Ложь);
		
		// 23 февраля - День защитника Отечества.
		ДобавитьПраздничныйДень(ПраздничныеДни, "23.02", НомерГода);
		
		// 8 марта - Международный женский день.
		ДобавитьПраздничныйДень(ПраздничныеДни, "08.03", НомерГода);
		
		// 1 мая - Праздник Весны и Труда.
		ДобавитьПраздничныйДень(ПраздничныеДни, "01.05", НомерГода);
		
		// 9 мая - День Победы
		ДобавитьПраздничныйДень(ПраздничныеДни, "09.05", НомерГода);
		
		// 12 июня - День России
		ДобавитьПраздничныйДень(ПраздничныеДни, "12.06", НомерГода);
		
		// 4 ноября - День народного единства.
		ДобавитьПраздничныйДень(ПраздничныеДни, "04.11", НомерГода);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПраздничныйДень(ПраздничныеДни, ПраздничныйДень, НомерГода, ПереноситьВыходной = Истина) 
	
	ДеньМесяц = СтрРазделить(ПраздничныйДень, ".");
	
	НоваяСтрока = ПраздничныеДни.Добавить();
	НоваяСтрока.Дата = Дата(НомерГода, ДеньМесяц[1], ДеньМесяц[0]);
	НоваяСтрока.ПереноситьВыходной = ПереноситьВыходной;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли