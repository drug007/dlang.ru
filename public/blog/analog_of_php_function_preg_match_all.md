# Написание аналога функции PHP `preg_match_all` на языке программирования D

**Автор**: DarkRIDDeR (25.08.2017)

---

В PHP есть очень удобная функция для глобального поиска шаблона регулярного выражения в строке `preg_match_all`. Давайте напишем аналогичный класс статических методов для реализации этой функции с разными флагами на языке программирования D.

Описание функции:

```int preg_match_all ( string $pattern , string $subject [, array &amp;$matches [, int $flags = PREG_PATTERN_ORDER [, int $offset = 0 ]]] )```

Функция ищет в строке `subject` все совпадения с шаблоном `pattern` и помещает результат в массив `matches` в порядке, определяемом комбинацией флагов `flags`.
После нахождения первого соответствия последующие поиски будут осуществляться не с начала строки, а от конца последнего найденного вхождения.

Данная функцию очень удобна и чаще всего она применяется с третьим параметром, чтобы обработать полученный массив совпадений шаблона. В D подобной регулярной функции нет. Мне вообще не сильно нравятся, как реализованы регулярные выражения в D. Ну да ладно.

Полную документацию по функции можете посмотреть здесь http://php.net/manual/ru/function.preg-match-all.php

Возможные флаги функции `preg_match_all`:

- `PREG_PATTERN_ORDER` – упорядочивает результаты так, что элемент `$matches[0]` содержит массив полных вхождений шаблона, элемент `$matches[1]` содержит массив вхождений первой подмаски, и так далее;
- `PREG_SET_ORDER` – упорядочивает результаты так, что элемент `$matches[0]` содержит первый набор вхождений, элемент `$matches[1]` содержит второй набор вхождений, и так далее;
- `PREG_OFFSET_CAPTURE` – в случае, если этот флаг указан, для каждой найденной подстроки будет указана ее позиция в исходной строке. Необходимо помнить, что этот флаг меняет формат возвращаемого массива `matches` в массив, каждый элемент которого содержит массив, содержащий в индексе с номером 0 найденную подстроку, а смещение этой подстроки в параметре `subject` — в индексе 1.

Не будем заморачиваться с реализацией через передачу константы, как в PHP, или через шаблоны в D. Создадим для каждого флага PHP данной функции аналогичные статические методы. Параметр `offset` оставим за бортом. Класс давайте назовём `PReg`. Вырисовывается следующая структура:

```d
class PReg
{
	public static:
 
	… matchAllPatternOrder (...) {...}
	… matchAllSetOrder (...){...}
	… matchAllOffsetCapture (…) {...}
}
```

Как параметры будем передавать строку для поиска (тип `string`), регулярное выражение (тип ???) и переменную для вывода количества совпадений шаблона регулярного выражения (тип `out int`). Тип регулярного выражения можно посмотреть, чтобы не капаться в модуле, применив такую хитрость:

```writeln(typeof(regex(`\d+`)).stringof);```

Также как аргумент вы без проблем сможете передавать compile-time регулярное выражение (`ctRegex`). Для данного типа создадим алиас типа, чтобы поудобнее было.
Функция `matchAllPatternOrder` и `matchAllSetOrder` будет возвращать двумерный массив строк, для них тоже создадим алиас типов (мне так кажется, что путаницы меньше). `MatchAllOffsetCapture` пока оставим на закуску.

В итоге у нас получается:

```d
class PReg
{
	private static alias typeRegex = Regex!char;
 
	public static:	
	alias typePatternOrder = string[];
	alias typeSetOrder = string[];
 
	typePatternOrder[] matchAllPatternOrder (string subject, typeRegex obRegex, out int count) {..}
	typeSetOrder[] matchAllSetOrder (string subject, typeRegex obRegex, out int count){...}
	… matchAllOffsetCapture (string subject, typeRegex obRegex, out int count)	{...}
}
```

Привожу пример реализованной функции `matchAllPatternOrder` (основные моменты пояснены ниже):

```d
typePatternOrder[] matchAllPatternOrder (string subject, typeRegex obRegex, out int count)
{
	typePatternOrder[] matches;
	auto stdMatches = matchAll(subject, obRegex);
 
	while (!stdMatches.empty) {
		matches.length++;
		matches[0] ~= stdMatches.front.hit;
 
		for (int i = 1; i < stdMatches.front.length; i++) {
			matches.length++;
			matches[count+1] ~= stdMatches.front[i];
		}
		stdMatches.popFront();
		count++;
	}
	return matches;
```


- Функция `matchAll` осуществляет глобальный поиск шаблона регулярного выражения `obRegex`.
- Цикл `while` файл перебирает найденные совпадения пока они не закончатся (проверка с помомощью `stdMatches.empty`);
- `stdMatches.front` хранит строку и найденные подстроки;
- `stdMatches.front.hit` возвращает всё строку входящую в найденный шаблон;
- `stdMatches.front[i]` возвращает найденные части по позиции маски;
- `stdMatches.popFront()` переход к следующей найденной строке.

Реализация функции `matchAllSetOrder` по сути ничем сильно не отличается кроме как позициями найденных строк в массиве (она даже проще). Приведу лишь реализованный вариант:

```d
typeSetOrder[] matchAllSetOrder (string subject, typeRegex obRegex, out int count)
{
	typeSetOrder[] matches;
	auto stdMatches = matchAll(subject, obRegex);
 
	while (!stdMatches.empty) {
		for (int i = 0; i < stdMatches.front.length; i++) {
			matches.length++;
			matches[count] ~= stdMatches.front[i];
		}
		stdMatches.popFront();
		count++;
	}
	return matches;
}
```

Реализация функции `matchAllOffsetCapture` имеет свои особенности. Найденные данные функции будем хранить в двумерном массиве картежа типов `Tuple!(string, «text», int, «position»)`, по которому можно будет получить позицию и найденую строку. Реализация:

```d
alias typeOffsetCapture = Tuple!(string, "text", int, "position")[];
 
typeOffsetCapture[] matchAllOffsetCapture (string subject, typeRegex obRegex, out int count)
	{
		typeOffsetCapture[] matches;
 
		auto stdMatches = matchAll(subject, obRegex);
		matches.length = stdMatches.front.length;
 
		while (!stdMatches.empty) {
			Tuple!(string, "text", int, "position") match;
			match.text = stdMatches.front.hit;
			match.position = cast(int)(match.text.ptr - subject.ptr);
			matches[0].length = count+1;
			matches[0][count] = match;
			for (int i = 1; i < stdMatches.front.length; i++) {
				matches[i].length = matches[0].length;
				match.text = stdMatches.front[i];
				match.position = cast(int)(stdMatches.front[i].ptr - subject.ptr);
				matches[i][count] = match;
			}
			stdMatches.popFront();
			count++;
		}
		return matches;
	}
```

Единственное, что здесь важно отметить, как определяются позиции, а именно:

```d
match.position = cast(int)(match.text.ptr - subject.ptr);
```

Позиция определяется через разность указателей позиций элементов массива. Также здесь выполняется приведение типа к int, так как многие процессоры уже использует 64-х битное представление, и указатели будут иметь тип long.

Полная реализация модуля с тестами представлена ниже:

```d
module preg;
 
import std.string: format;
import std.typecons;
import std.regex: Regex, regex, ctRegex, matchFirst, matchAll;
 
// analog of preg regex in php
 
class PReg
{
	private static alias typeRegex = Regex!char;
 
	public static:
 
	alias typePatternOrder = string[];
	alias typeSetOrder = string[];
	alias typeOffsetCapture = Tuple!(string, "text", int, "position")[];
 
	typePatternOrder[] matchAllPatternOrder (string subject, typeRegex obRegex, out int count)
	{
		typePatternOrder[] matches;
		auto stdMatches = matchAll(subject, obRegex);
 
		while (!stdMatches.empty) {
			matches.length++;
			matches[0] ~= stdMatches.front.hit;
 
			for (int i = 1; i < stdMatches.front.length; i++) {
				matches.length++;
				matches[count+1] ~= stdMatches.front[i];
			}
			stdMatches.popFront();
			count++;
		}
		return matches;
	}
 
 
	typeSetOrder[] matchAllSetOrder (string subject, typeRegex obRegex, out int count)
	{
		typeSetOrder[] matches;
 
		auto stdMatches = matchAll(subject, obRegex);
 
		while (!stdMatches.empty) {
			for (int i = 0; i < stdMatches.front.length; i++) {
				matches.length++;
				matches[count] ~= stdMatches.front[i];
			}
			stdMatches.popFront();
			count++;
		}
		return matches;
	}
 
	typeOffsetCapture[] matchAllOffsetCapture (string subject, typeRegex obRegex, out int count)
	{
		typeOffsetCapture[] matches;
 
		auto stdMatches = matchAll(subject, obRegex);
		matches.length = stdMatches.front.length;
 
		while (!stdMatches.empty) {
			Tuple!(string, "text", int, "position") match;
			match.text = stdMatches.front.hit;
			match.position = cast(int)(match.text.ptr - subject.ptr);
			matches[0].length = count+1;
			matches[0][count] = match;
			for (int i = 1; i < stdMatches.front.length; i++) {
				matches[i].length = matches[0].length;
				match.text = stdMatches.front[i];
				match.position = cast(int)(stdMatches.front[i].ptr - subject.ptr);
				matches[i][count] = match;
			}
			stdMatches.popFront();
			count++;
		}
		return matches;
	}
}
 
unittest
{
	import std.stdio;
	writeln("test PReg.matchAll");
 
	int count;
 
	auto matches1 = PReg.matchAllPatternOrder(`one two`, regex(`(\w)(\w)\w+`), count);
	assert(matches1[0][0] == `one`);
	assert(matches1[0][1] == `two`);
	assert(matches1[1][0] == `o`);
	assert(matches1[1][1] == `n`);
	assert(matches1[2][0] == `t`);
	assert(matches1[2][1] == `w`);
	assert(count == 2);
 
	auto matches2 = PReg.matchAllSetOrder(`one two`, regex(`(\w)(\w)\w+`), count);
	assert(matches2[0][0] == `one`);
	assert(matches2[0][1] == `o`);
	assert(matches2[0][2] == `n`);
	assert(matches2[1][0] == `two`);
	assert(matches2[1][1] == `t`);
	assert(matches2[1][2] == `w`);
	assert(count == 2);
 
	auto matches3 = PReg.matchAllOffsetCapture(`one two`, ctRegex!(`(\w)(\w)\w+`), count);
	assert(matches3[0][0].text == "one");
	assert(matches3[0][0].position == 0);
	assert(matches3[0][1].text == "two");
	assert(matches3[0][1].position == 4);
 
	assert(matches3[1][0].text == "o");
	assert(matches3[1][0].position == 0);
	assert(matches3[1][1].text == "t");
	assert(matches3[1][1].position == 4);
 
	assert(matches3[2][0].text == "n");
	assert(matches3[2][0].position == 1);
	assert(matches3[2][1].text == "w");
	assert(matches3[2][1].position == 5);
	assert(count == 2);
}
```

Надеюсь, что из этой статьи вы подчеркнули для себя что-то полезное и интересное. Всем спасибо!