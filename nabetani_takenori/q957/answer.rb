require 'optparse'

class MonotonicSequenceGenerator
  @src_string

  def initialize(num_str)
    if num_str.nil? or num_str.empty?
      raise "Argument error."
    end
    @src_string = num_str
  end

  # num_digits_first: 最初の数値の桁数
  def gen_seq(num_digits_first = 1)
    seq = []
    next_num = ''
    @src_string.each_char do |c|
      next_num = next_num + c
      if seq.last == nil
        # 最初の数。
        if next_num.length >= num_digits_first
          # 引数で指定された桁数になったら数列に追加する
          seq << next_num
          next_num = ''
        end
      elsif c == "0" and next_num == "0"
        # 0はじまりの数に遭遇したとき。
        # 一つ前の要素の末尾に0を追加する
        seq[-1] = seq[-1] + c
        next_num = ''
      elsif next_num.to_i > seq.last.to_i
        # next_numが一つ前の数値をこえた場合。
        # 数列に追加する
        seq << next_num
        next_num = ''
      end
    end

    unless next_num.empty?
      seq << next_num
    end

    # 末尾の数値が最後から2番目の数より小さい場合は
    # 最後から2番目の数に連結する。
    if seq[-2].to_i >= seq[-1].to_i
      seq[-2] = seq[-2] + seq[-1]
      seq.pop
    end

    seq
  end

  # 最大の要素数を持つ数列を返す
  def gen_seq_has_most_elements()
    most_elem_seq = []
    for i in 1 .. @src_string.chars.length
      seq = gen_seq(i)  # 最初の要素にi桁を持つ数列を生成する
      if seq.size > most_elem_seq.size
        most_elem_seq = seq
      end

      # 生成した数列の要素数が1だったら
      # それ以上増えないと判断して終了する
      if seq.size == 1
        break
      end
    end
    most_elem_seq
  end

end

def cmdline
  args = {}
  OptionParser.new do |parser|
    parser.on('-d', '--debug', 'デバッグ用に詳細な結果を出力する') {|v| args[:debug] = v}
    parser.parse!(ARGV)
  end 
  args
end

args = cmdline
first = true
while(s = gets)
  sp = s.split(" ")
  id = sp[0]
  str = sp[1]
  expect = sp[2].to_i

  generator = MonotonicSequenceGenerator.new(str)
  seq = generator.gen_seq_has_most_elements()
  if args[:debug]
    if seq.size == expect
      puts "[#{id}] OK."
    else
      puts "[#{id}] NG. Expect: #{expect}, Result: #{seq.size} #{seq.to_s}"
    end
  else
    # NGの結果のみ出力
    unless seq.size == expect
      unless first
        print ','
      end
      print "#{id}"
      first = false
    end
  end
end

puts ''

