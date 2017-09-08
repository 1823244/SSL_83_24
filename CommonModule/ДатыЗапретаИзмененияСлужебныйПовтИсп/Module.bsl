﻿#Область СлужебныеПроцедурыИФункции

// См. ДатыЗапретаИзменения.ШаблонДанныхДляПроверки.
Функция ШаблонДанныхДляПроверки() Экспорт
	
	ДанныеДляПроверки = Новый ТаблицаЗначений;
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Дата", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Раздел", Новый ОписаниеТипов("Строка,ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Объект", Метаданные.ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.Тип);
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

// Возвращает сведения о последней проверки версии действующих дат запрета изменения.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//   * Дата - Дата - дата и время последней проверки действующих дат.
//
Функция ПоследняяПроверкаВерсииДействующихДатЗапрета() Экспорт
	
	Возврат Новый Структура("Дата", '00010101');
	
КонецФункции

// Возвращает пустой раздел дат запрета.
Функция ПустойРаздел() Экспорт
	
	Возврат ДатыЗапретаИзмененияСлужебный.ПустаяСсылка(
		Тип("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
КонецФункции

#КонецОбласти
