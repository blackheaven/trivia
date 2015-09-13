$r = Random.new(0)
def rand(a)
  $r.rand a
end

$buff = []
def puts(a)
  $buff << a
end

require './bin/trivia'
