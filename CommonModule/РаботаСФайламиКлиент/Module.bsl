﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функция для работы со сканером.

// Открывает форму настройки сканирования.
Процедура ОткрытьФормуНастройкиСканирования() Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		ТекстСообщения = НСтр("ru = 'Сканирование поддерживается только в клиенте под управлением ОС Windows.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ТекстСообщения = НСтр("ru = 'Сканирование не поддерживается в веб-клиенте.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	КомпонентаУстановлена = РаботаСФайламиСлужебныйКлиент.ПроинициализироватьКомпоненту();
	
	Если Не КомпонентаУстановлена Тогда
		ТекстВопроса = НСтр("ru = 'Для продолжения работы необходимо установить компоненту сканирования. 
							|Установить компоненту?'");
		Обработчик = Новый ОписаниеОповещения("ПоказатьВопросУстановкиКомпонентыСканирования", ЭтотОбъект, КомпонентаУстановлена);
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуНастройкиСканированияЗавершение(КомпонентаУстановлена, Неопределено);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Команды работы с файлами

// Открывает файл для просмотра или редактирования.
//  Если файл открывается для просмотра, тогда получает файл в рабочий каталог пользователя,
// при этом ищет файл в рабочем каталоге и предлагает открыть существующий или получить файл с сервера.
//  Если файл открывается для редактирования, тогда открывает файл в рабочем каталоге (если есть) или
// получает его с сервера.
//
// Параметры:
//  ДанныеФайла       - Структура - данные файла.
//  ДляРедактирования - Булево - Истина, если файл открывается для редактирования, иначе Ложь.
//
Процедура ОткрытьФайл(Знач ДанныеФайла, Знач ДляРедактирования = Ложь) Экспорт
	
	Если ДляРедактирования Тогда
		РаботаСФайламиСлужебныйКлиент.РедактироватьФайл(Неопределено, ДанныеФайла);
	Иначе
		РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла); 
	КонецЕсли;
	
КонецПроцедуры

// Открывает каталог на локальном компьютере в котором размещен этот файл.
//
// Параметры:
//  ДанныеФайла - Структура - структура с данными файла.
//
Процедура ОткрытьКаталогФайла(ДанныеФайла) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.КаталогФайла(Неопределено, ДанныеФайла);
	
КонецПроцедуры

// Обработчик команды добавления файлов.
//  Предлагает пользователю выбирать файлы в диалоге выбора файлов и
// пытается поместить выбранные файлы в хранилище файлов, когда:
// - размер файла не превышает максимально допустимый,
// - файл имеет допустимое расширение,
// - имеется свободное место в томе (при хранении файлов в томах),
// - прочие условия.
//
// Параметры:
//  ВладелецФайла      - Ссылка - владелец файла.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//  Фильтр             - Строка - необязательный параметр,
//                       позволяет задать фильтр выбираемого файла,
//                       например, картинки для номенклатуры.
//  ГруппаФайлов       - Ссылка - группа справочника с файлами, в которую будет добавлен новый файл.
//
Процедура ДобавитьФайлы(Знач ВладелецФайла, Знач ИдентификаторФормы, Знач Фильтр = "", ГруппаФайлов = Неопределено) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВладелецФайла",      ВладелецФайла);
	Параметры.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	Параметры.Вставить("Фильтр",             Фильтр);
	Параметры.Вставить("ГруппаФайлов",       ГруппаФайлов);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлыРасширениеПредложено", РаботаСФайламиСлужебныйКлиент, Параметры);
	РаботаСФайламиСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

// Создает новый файл интерактивно.
//
// Параметры:
//   ОбработчикРезультата - ОписаниеОповещения - Описание процедуры, принимающей
//                          результат работы метода.
//
//   ВладелецФайла - ЛюбаяСсылка - определяет группу, в которой создается Элемент.
//
//   ФормаВладелец - УправляемаяФорма - форма, из которой вызвано создание файла.
//
//   РежимСоздания - Неопределено, Число - режим создания файла:
//       - Неопределено - значение по умолчанию. Показать диалог выбора режима создания файла.
//       - Число - Создать файл указанным способом:
//           * 1 - из шаблона (копированием другого файла),
//           * 2 - с диска (из файловой системы клиента),
//           * 3 - со сканера.
//
//   НеОткрыватьКарточку - Булево - действие после создания:
//       * Ложь - Значение по умолчанию. Открывать карточку файла после создания.
//       * Истина - Не открывать карточку файла после создания.
//
Процедура ДобавитьФайл(ОбработчикРезультата,
	ВладелецФайла,
	ФормаВладелец,
	РежимСоздания = Неопределено,
	НеОткрыватьКарточку = Ложь) Экспорт
	
	Если РежимСоздания = Неопределено Тогда
		РаботаСФайламиСлужебныйКлиент.ДобавитьФайл(ОбработчикРезультата, ВладелецФайла, ФормаВладелец, , НеОткрыватьКарточку);
	Иначе
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ОбработчикРезультата", ОбработчикРезультата);
		ПараметрыВыполнения.Вставить("ВладелецФайла", ВладелецФайла);
		ПараметрыВыполнения.Вставить("ФормаВладелец", ФормаВладелец);
		ПараметрыВыполнения.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", НеОткрыватьКарточку);
		РаботаСФайламиСлужебныйКлиент.ДобавитьПослеВыбораРежимаСоздания(РежимСоздания, ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму для настройки рабочего каталога.
Процедура ОткрытьФормуНастройкиРабочегоКаталога() Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОсновногоРабочегоКаталога");
	
КонецПроцедуры

// Задает вопрос о продолжении закрытия формы если в форме остались захваченные файлы:
// "Один или несколько файлов заняты для редактирования. Продолжить?"
// Вызывается из ПередЗакрытием форм с файлами.
//
// По ссылке объекта проверяет остались ли захваченные файлы.
// Если захваченные файлы остались, в параметре Отказ устанавливается значение Истина,
// Пользователю задается вопрос.
// Если пользователь ответил утвердительно, тогда форма снова закрывается.
//
// Параметры:
//   Форма            - УправляемаяФорма - форма, в которой редактируется файл.
//   Отказ            - Булево - параметр события ПередЗакрытием.
//   ЗавершениеРаботы - Булево - признак того, что форма закрывается в процессе завершения работы приложения.
//   ОбъектСсылка     - ЛюбаяСсылка - ссылка на владельца файла.
//   ИмяРеквизита     - Строка - имя реквизита типа Булево, в котором хранится признак того,
//                               что вопрос уже выводился.
//
// Пример:
//
//	&НаКлиенте
//	Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
//		РаботаСФайламиКлиент.ПоказатьПодтверждениеЗакрытияФормыСФайлами(ЭтотОбъект, Отказ, ЗавершениеРаботы, Объект.Ссылка);
//	КонецПроцедуры
//
Процедура ПоказатьПодтверждениеЗакрытияФормыСФайлами(Форма, Отказ, ЗавершениеРаботы, ОбъектСсылка, 
	ИмяРеквизита = "МожноЗакрытьФормуСФайлами") Экспорт
	
	ИмяПроцедуры = "РаботаСФайламиКлиент.ПоказатьПодтверждениеЗакрытияФормыСФайлами";
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Форма", Форма, Тип("УправляемаяФорма"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Отказ", Отказ, Тип("Булево"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ЗавершениеРаботы", ЗавершениеРаботы, Тип("Булево"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ИмяРеквизита", ИмяРеквизита, Тип("Строка"));
		
	Если Форма[ИмяРеквизита] Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Количество = РаботаСФайламиСлужебныйВызовСервера.КоличествоФайловЗанятыхТекущимПользователем(ОбъектСсылка);
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ТекстВопроса = НСтр("ru = 'Один или несколько файлов заняты для редактирования.
	                          |
	                          |Продолжить?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(Форма, Отказ, ЗавершениеРаботы, ТекстВопроса, ИмяРеквизита);
	
КонецПроцедуры

// Копирует существующий файл.
//
// Параметры:
//  ВладелецФайла - ЛюбаяСсылка - владелец файла.
//  ФайлОснование - СправочникСсылка - откуда копируется Файл.
//
Процедура СкопироватьФайл(ВладелецФайла, ФайлОснование) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначениеКопирования", ФайлОснование);
	ПараметрыФормы.Вставить("ВладелецФайла", ВладелецФайла);
	
	ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Сохраняет файл вместе вместе с ЭП.
// Используется в обработчике команды сохранения файла.
//
// Параметры:
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
Процедура СохранитьВместеСЭП(Знач ПрисоединенныйФайл, Знач ИдентификаторФормы) Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(ПрисоединенныйФайл);
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
	ПараметрыВыполнения.Вставить("ДанныеФайла",        ДанныеФайла);
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", ИдентификаторФормы);
	
	ОписаниеДанных = Новый Структура;
	ОписаниеДанных.Вставить("ЗаголовокДанных",     НСтр("ru = 'Файл'"));
	ОписаниеДанных.Вставить("ПоказатьКомментарий", Истина);
	ОписаниеДанных.Вставить("Представление",       ПараметрыВыполнения.ДанныеФайла.Ссылка);
	Если ЗначениеЗаполнено(ПараметрыВыполнения.ДанныеФайла.ТекущаяВерсия) Тогда
		ОписаниеДанных.Вставить("Объект",          ПараметрыВыполнения.ДанныеФайла.ТекущаяВерсия);
	Иначе
		ОписаниеДанных.Вставить("Объект",          ПрисоединенныйФайл);
	КонецЕсли;
	
	ОписаниеДанных.Вставить("Данные",
		Новый ОписаниеОповещения("ПриСохраненииДанныхФайла", РаботаСФайламиСлужебныйКлиент, ПараметрыВыполнения));
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	МодульЭлектроннаяПодписьКлиент.СохранитьДанныеВместеСПодписью(ОписаниеДанных);
	
КонецПроцедуры

// Сохраняет файл в каталог на диске.
// Так же используется, как вспомогательная функция при сохранении файла с ЭП.
//
// Параметры:
//  ДанныеФайла  - Структура - данные файла.
//
// Возвращаемое значение:
//  Строка - имя сохраненного файла.
//
Процедура СохранитьФайлКак(Знач ДанныеФайла) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

// Открывает форму файла из формы элемента
// справочника файлов. Форма элемента закрывается.
// 
// Параметры:
//  Форма     - УправляемаяФорма - форма справочника присоединенных файлов.
//
Процедура ПерейтиКФормеФайла(Знач Форма) Экспорт
	
	ПрисоединенныйФайл = Форма.Ключ;
	
	Форма.Закрыть();
	
	Для Каждого ОкноКП Из ПолучитьОкна() Цикл
		
		Содержимое = ОкноКП.ПолучитьСодержимое();
		
		Если Содержимое = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Содержимое.ИмяФормы = "Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл" Тогда
			Если Содержимое.Параметры.Свойство("ПрисоединенныйФайл")
				И Содержимое.Параметры.ПрисоединенныйФайл = ПрисоединенныйФайл Тогда
				ОкноКП.Активизировать();
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ОткрытьФормуФайла(ПрисоединенныйФайл);
	
КонецПроцедуры

// Открывает форму выбора файлов.
// Используется в обработчике выбора для переопределения стандартного поведения.
//
// Параметры:
//  ВладелецФайлов       - Ссылка - ссылка на объект с файлами.
//  ЭлементФормы         - ТаблицаФормы, ПолеФормы - элемент формы, которому будет отправлено
//                         оповещение о выборе.
//  СтандартнаяОбработка - Булево - (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуВыбораФайлов(Знач ВладелецФайлов, Знач ЭлементФормы, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;

	Если ВладелецФайлов.Пустая() Тогда
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиЗаписиПослеЗавершения", ЭтотОбъект);
		ПоказатьВопрос(ОбработчикОповещенияОЗакрытии,
			НСтр("ru = 'Данные еще не записаны. 
				|Переход к ""Присоединенные файлы"" возможен только после записи данных.'"),
				РежимДиалогаВопрос.ОК);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ВладелецФайла", ВладелецФайлов);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, ЭлементФормы);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму файла.
// Может использоваться как обработчик открытия файла.
//
// Параметры:
//  ПрисоединенныйФайл   - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  СтандартнаяОбработка - Булево - (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуФайла(Знач ПрисоединенныйФайл, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПрисоединенныйФайл", ПрисоединенныйФайл);
		
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл", ПараметрыФормы, , ПрисоединенныйФайл);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет печать файлов.
//
// Параметры:
//  ДанныеФайлов       - Массив - массив структур с данными файлов.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
Процедура НапечататьФайлы(ДанныеФайлов, ИдентификаторФормы = Неопределено) Экспорт
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("НомерФайла",   0);
	ПараметрыВыполнения.Вставить("ДанныеФайлов", ДанныеФайлов);
	ПараметрыВыполнения.Вставить("ДанныеФайла",  ДанныеФайлов);
	ПараметрыВыполнения.Вставить("УникальныйИдентификатор", ИдентификаторФормы);
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
	ВыполнитьОбработкуОповещения(Обработчик);
	
КонецПроцедуры

// Подписывает файл.
//
// Параметры:
//  ПрисоединенныйФайл      - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы      - УникальныйИдентификатор - идентификатор управляемой формы.
//  ДополнительныеПараметры - Неопределено - стандартное поведение (см. ниже).
//                          - Структура - со свойствами:
//       * ДанныеФайла            - Структура - данные файла, если свойства нет, будет вставлено.
//       * ОбработкаРезультата    - ОписаниеОповещения - при вызове передается значение типа Булево,
//                                  если Истина - файл успешно подписан, иначе не подписан,
//                                  если свойства нет, оповещение не будет вызвано.
//
Процедура ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран файл, который нужно подписать.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Добавление электронных подписей не поддерживается.'"));
		Возврат;
	КонецЕсли;
	
	МодульЭлектроннаяПодписьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьКлиент");
	
	Если Не МодульЭлектроннаяПодписьКлиент.ИспользоватьЭлектронныеПодписи() Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Чтобы добавить электронную подпись, включите
			           |в настройках программы использование электронных подписей.'"));
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.Свойство("ДанныеФайла") Тогда
		ДополнительныеПараметры.Вставить("ДанныеФайла", РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(
			ПрисоединенныйФайл, ИдентификаторФормы));
	КонецЕсли;
	
	ОбработкаРезультата = Неопределено;
	ДополнительныеПараметры.Свойство("ОбработкаРезультата", ОбработкаРезультата);
	
	РаботаСФайламиСлужебныйКлиент.ПодписатьФайл(ПрисоединенныйФайл,
		ДополнительныеПараметры.ДанныеФайла, ИдентификаторФормы, ОбработкаРезультата);
	
КонецПроцедуры

// См. РаботаСФайлами.ДанныеФайла.
Функция ДанныеФайла(Знач ФайлСсылка,
                    Знач ИдентификаторФормы = Неопределено,
                    Знач ПолучатьСсылкуНаДвоичныеДанные = Истина,
                    Знач ДляРедактирования = Ложь) Экспорт
	
	Возврат РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(
		ФайлСсылка,
		ИдентификаторФормы,
		ПолучатьСсылкуНаДвоичныеДанные,
		ДляРедактирования);

КонецФункции

// Получает файл из хранилища файлов в рабочий каталог пользователя.
// Аналог интерактивного действия Просмотреть или Редактировать без открытия полученного файла.
//   Свойство ТолькоПросмотр полученного файла будет установлено в зависимости от того захвачен
// файл для редактирования или нет. Если не захвачен - устанавливается только просмотр.
//   Если в рабочем каталоге уже существует файл, тогда он будет удален и заменен файлом,
// полученным из хранилища файлов.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение, которое выполняется после получения файла в
//   рабочий каталог пользователя. В качестве результата возвращается Структура со свойствами:
//     * ПолноеИмяФайла - Строка - полное имя файла (с путем).
//     * ОписаниеОшибки - Строка - текст ошибки, если получить файл не удалось.
//
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
//  ДополнительныеПараметры - Неопределено - использовать значения по умолчанию.
//     - Структура - с необязательными свойствами:
//         * ДляРедактирования - Булево    - начальное значение Ложь. Если Истина,
//                                           тогда файл будет захвачен для редактирования.
//         * ДанныеФайла       - Структура - свойства файла, которые можно передать для ускорения
//                                           если они ранее были получены на клиент с сервера.
//
Процедура ПолучитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.ПолучитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры);
	
КонецПроцедуры

// Помещает файл из рабочего каталога пользователя в хранилище файлов.
// Аналог интерактивного действия Закончить редактирование.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение, которое выполняется после помещения файла в
//   хранилище файлов. В качестве результата возвращается Структура со свойствами:
//     * ОписаниеОшибки - Строка - текст ошибки, если поместить файл не удалось.
//
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
//  ДополнительныеПараметры - Неопределено - использовать значения по умолчанию.
//     - Структура - с необязательными свойствами:
//         * ПолноеИмяФайла - Строка - если заполнено, то указанный файл будет помещен в рабочий каталог
//                                     пользователя, а затем в хранилище файлов.
//         * ДанныеФайла    - Структура - свойства файла, которые можно передать для ускорения
//                                        если они ранее были получены на клиент с сервера.
//
Процедура ПоместитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.ПоместитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура предназначена для печати файла соответствующим приложением
//
// Параметры
//  ДанныеФайла          - Структура - данные файла.
//  ИмяОткрываемогоФайла - Строка - полное имя файла.
//
Процедура НапечататьФайлПриложением(ДанныеФайла, ИмяОткрываемогоФайла)
	
	РасширенияИсключения = 
	" m3u, m4a, mid, midi, mp2, mp3, mpa, rmi, wav, wma, 
	| 3g2, 3gp, 3gp2, 3gpp, asf, asx, avi, m1v, m2t, m2ts, m2v, m4v, mkv, mov, mp2v, mp4, mp4v, mpe, mpeg, mts, vob, wm, wmv, wmx, wvx,
	| 7z, zip, rar, arc, arh, arj, ark, p7m, pak, package, 
	| app, com, exe, jar, dll, res, iso, isz, mdf, mds,
	| cf, dt, epf, erf";
	
	Расширение = НРег(ДанныеФайла.Расширение);
	
	Если СтрНайти(РасширенияИсключения, " " + Расширение + ",") > 0 Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Печать файлов данного типа не поддерживается.'"), Расширение);
		ПоказатьПредупреждение(, ТекстСообщения);
		
		Возврат;
	
	ИначеЕсли Расширение = "grs" Тогда
		
		Схема = Новый ГрафическаяСхема;
		Схема.Прочитать(ИмяОткрываемогоФайла);
		Схема.Напечатать();;
		
	Иначе
		
		Попытка
			
			СистемнаяИнфо = Новый СистемнаяИнформация;
			Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86
				Или СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
				ИмяОткрываемогоФайла = СтрЗаменить(ИмяОткрываемогоФайла, "/", "\");
			КонецЕсли;
			
			НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла);
			
		Исключение
			
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Описание=""%1""'"),
				КраткоеПредставлениеОшибки(Инфо))); 
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура печати Файла
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещения для дальнейшего вызова.
//  ПараметрыВыполнения  - Структура - со свойствами:
//        * НомерФайла               - Число - номер текущего файла,
//        * ДанныеФайла              - Структура - данные файла,
//        * УникальныйИдентификатор  - УникальныйИдентификатор.
//
Процедура НапечататьФайлыВыполнение(ОбработчикРезультата, ПараметрыВыполнения) Экспорт
	
	ОбработкаПрерыванияПользователя();
	
	Если ПараметрыВыполнения.НомерФайла >= ПараметрыВыполнения.ДанныеФайлов.Количество() Тогда
		Возврат;
	КонецЕсли;
	ПараметрыВыполнения.ДанныеФайла = 
		РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляПечати(ПараметрыВыполнения.ДанныеФайлов[ПараметрыВыполнения.НомерФайла]);
		
	Если ПараметрыВыполнения.ДанныеФайла.Свойство("ТабличныйДокумент") Тогда
		ПараметрыВыполнения.ДанныеФайла.ТабличныйДокумент.Напечатать();
		// переходим к печати следующего файла.
		ПараметрыВыполнения.НомерФайла = ПараметрыВыполнения.НомерФайла + 1;
		Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
		ВыполнитьОбработкуОповещения(Обработчик);
		Возврат
	КонецЕсли;
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлПослеПолученияВерсииВРабочийКаталог", ЭтотОбъект, ПараметрыВыполнения);
	РаботаСФайламиСлужебныйКлиент.ПолучитьФайлВерсииВРабочийКаталог(
		Обработчик,
		ПараметрыВыполнения.ДанныеФайла,
		"",
		ПараметрыВыполнения.УникальныйИдентификатор);
	
КонецПроцедуры

// Процедура печати Файла после получения на диск
//
// Параметры:
//  ПараметрыВыполнения  - Структура - со свойствами:
//        * НомерФайла               - Число - номер текущего файла,
//        * ДанныеФайла              - Структура - данные файла,
//        * УникальныйИдентификатор  - УникальныйИдентификатор.
//
Процедура НапечататьФайлПослеПолученияВерсииВРабочийКаталог(Результат, ПараметрыВыполнения) Экспорт

	Если Результат.ФайлПолучен Тогда
		
		Если ПараметрыВыполнения.НомерФайла >= ПараметрыВыполнения.ДанныеФайлов.Количество() Тогда
			Возврат;
		КонецЕсли;
	
		НапечататьФайлПриложением(ПараметрыВыполнения.ДанныеФайла, Результат.ПолноеИмяФайла);
		
	КонецЕсли;

	// переходим к печати следующего файла.
	ПараметрыВыполнения.НомерФайла = ПараметрыВыполнения.НомерФайла + 1;
	Обработчик = Новый ОписаниеОповещения("НапечататьФайлыВыполнение", ЭтотОбъект, ПараметрыВыполнения);
	ВыполнитьОбработкуОповещения(Обработчик);
	
КонецПроцедуры

// Выполняет печать файла внешним приложением.
//
// Параметры
//  ИмяОткрываемогоФайла - Строка - полное имя файла.
//
Процедура НапечататьИзПриложенияПоИмениФайла(ИмяОткрываемогоФайла)
	
	Если Не ЗначениеЗаполнено(ИмяОткрываемогоФайла) Тогда
		Возврат;
	КонецЕсли;
		
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 
	 Или СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		
		Shell = Новый COMОбъект("Shell.Application");
		Shell.ShellExecute(ИмяОткрываемогоФайла, "", "", "print", 1);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПоказатьВопросУстановкиКомпонентыСканирования(Результат, КомпонентаУстановлена) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Обработчик = Новый ОписаниеОповещения("ОткрытьФормуНастройкиСканированияЗавершение", ЭтотОбъект);
		РаботаСФайламиСлужебныйКлиент.УстановитьКомпоненту(Обработчик);
	КонецЕсли;
	
КонецФункции

Процедура ОткрытьФормуНастройкиСканированияЗавершение(КомпонентаУстановлена, ПараметрыВыполнения) Экспорт
	
	Если Не КомпонентаУстановлена Тогда
		Возврат;
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КомпонентаУстановлена", КомпонентаУстановлена);
	ПараметрыФормы.Вставить("ИдентификаторКлиента",  ИдентификаторКлиента);
	
	ОткрытьФорму("Обработка.Сканирование.Форма.НастройкаСканирования", ПараметрыФормы);
	
КонецПроцедуры

Процедура ВопросОНеобходимостиЗаписиПослеЗавершения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
