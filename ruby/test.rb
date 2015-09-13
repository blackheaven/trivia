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
  $buff
end

old = runVersion('trivia', 0)
new = runVersion('new_trivia', 0)

s = old.size - 1
i = 0
i += 1 while i < s && old[i] == new[i]

if i == s
  print "ok\n"
else
  print "Err\n"
  d = [0, (i-5)].max
  (d..i).each do |line|
    print "-" + old[line] + "\n"
    print "+" + new[line] + "\n"
  end
end
