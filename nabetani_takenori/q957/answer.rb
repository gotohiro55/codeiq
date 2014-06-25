class MonotonicSequenceGenerator
  @src_string
  @mono_sequences

  def initialize(num_str)
    if num_str.nil? or num_str.empty?
      raise "Argument error."
    end
    @src_string = num_str
    @mono_sequences = []
  end

  # num_digits_first: 最初の数値の桁数
  def gen_seq(num_digits_first = 1)
    seq = []
    next_num = ''
    @src_string.each_char do |c|
      next_num = next_num + c
      if seq.last == nil
        if next_num.length >= num_digits_first
          seq << next_num
          next_num = ''
        end
      elsif c == "0" and next_num == "0"
        seq[-1] = seq[-1] + c
        next_num = ''
      elsif next_num.to_i > seq.last.to_i
        seq << next_num
        next_num = ''
      end
    end

    unless next_num.empty?
      seq << next_num
    end

    if seq[-2].to_i >= seq[-1].to_i
      seq[-2] = seq[-2] + seq[-1]
      seq.pop
    end

    seq
  end

  # 最大の要素数を持つ数列を返す
  def gen_seq_has_most_elements()

  end

end

while(s = gets)
  sp = s.split(" ")
  id = sp[0]
  str = sp[1]
  num_elem = sp[2]

  generator = MonotonicSequenceGenerator.new(str)
  p generator.gen_seq()
end
