Sample ruby scripts
====
### fibonacci
Computes the n<sup>th</sup> Fibonacci number in O(log n) time using matrix formula

http://en.wikipedia.org/wiki/Fibonacci_number#Matrix_form

### mp3
Computes total duration of mp3 files in a given directory.

### PKP

Simple DSL to find PKP connections. Kraków is a default station and also are current time and date.

Examples:

```ruby
find do
  from 'Chrzanów'
  to 'Krzeszowice'
  after '12:55'
  date '14.11.14'
end

find 'Krynica', 'Muszyna'

find do
  to('Poznań').after('10:00')
end
```
