foo.bar %{baz}

a.b(c, d)

a.b()

foo
  .bar
  &.baz

a!

a.()

a.(1, 2, 3)

a::b

foo.bar = 1

a?

a(&block)

a(**kwargs)

a.b.c

a(b, c)

a()

a(*args)

a b, c

a.b c, d

foo.foo, bar.bar = 1, 2

a&.b

a&.()

a&.b(c)

a&.b()

foo :a, :b if bar? or baz and qux

foo(:a,

	 :b
)

foo(*rest)

foo(:a, :h => [:x, :y], :a => :b, &:bar)

hi 123, { :there => :friend, **{}, whatup: :dog }

foo :a, b: true do |a, b| puts a end

hi there: :friend

hi :there => :friend, **{}, whatup: :dog

hi(:there => :friend, **{}, whatup: :dog)

foo({ a: true, b: false, }, &:block)

hi :there => :friend

foo(:a,
:b,
)

foo(
:a,
b: :c,
)

foo a: true, b: false, &:block

some_func 1, kwarg: 2

Kernel.Integer(10)

x.each { }

foo.map { $& }

A::B::C :foo

A::B::C(:foo)

A::B::C(:foo) { }

foo("a": -1)

foo bar: { baz: qux do end }

foo bar: { **kw do end }

foo "#{bar.map do "baz" end}" do end

foo class Bar baz do end end

foo module Bar baz do end end

foo [baz do end]

p begin 1.times do 1 end end
