def runVersion(name, seed)
  $r = Random.new(seed)
  def rand(a)
    $r.rand a
  end

  $buff = []
  def puts(a)
    $buff << a
  end

  require './bin/' + name
end

runVersion('trivia', 0)
runVersion('new_trivia', 0)
