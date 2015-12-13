
Feature::Cache
==============

Simple value caching for a class

Overview
--------

```ruby
require "feature/cache"

class Person
  Feature::Cache.load(self)

  attr_reader :first_name
  attr_reader :last_name

  def full_name
    # This value is cached.
    cache[:full_name] ||= "#{first_name} #{last_name}"
  end

  def first_name=(s)
    cache.clear
    @first_name = s
  end

  def last_name=(s)
    cache.clear
    @last_name = s
  end
end
```

Full documentation is available at [rubydoc.info](http://www.rubydoc.info/github/dadooda/feature_cache/master/Feature/Cache).


Installation
------------

This project is a *sub*. For info on installing subs, click [here](https://github.com/dadooda/subs#installation).

For more info on subs, click [here](https://github.com/dadooda/subs).


Cheers!
-------

&mdash; Alex Fortuna, &copy; 2015
