require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/read', __FILE__)

describe "ARGF.read" do
  it_behaves_like :argf_read, :read

  before :each do
   
    @file1_name = fixture __FILE__, "file1.txt"
    @file2_name = fixture __FILE__, "file2.txt"
    @stdin_name = fixture __FILE__, "stdin.txt"

    @file1 = File.read @file1_name
    @file2 = File.read @file2_name
    @stdin = File.read @stdin_name
  end

  after :each do
    ARGF.close unless ARGF.closed?
  end

  it "reads the contents of a file" do
    argv [@file1_name] do
      ARGF.read().should == @file1
    end
  end

  it "treats first nil argument as no length limit" do
    argv [@file1_name] do
      ARGF.read(nil).should == @file1
    end
  end

  it "reads the contents of two files" do
    argv [@file1_name, @file2_name] do
      ARGF.read.should ==  @file1 + @file2
    end
  end

  it "reads the contents of one file and some characters from the second" do
    argv [@file1_name, @file2_name] do
      len = @file1.size + (@file2.size / 2)
      ARGF.read(len).should ==  (@file1 + @file2)[0,len]
    end
  end

  it "reads across two files consecutively" do
    argv [@file1_name, @file2_name] do
      ARGF.read(@file1.size - 2).should == @file1[0..-3]
      ARGF.read(2+5).should == @file1[-2..-1] + @file2[0,5]
    end
  end

  it "reads the contents of stdin" do
    stdin = ruby_exe("print ARGF.read", :args => "< #{@stdin_name}")
    stdin.should == @stdin
  end

  it "reads the contents of one file and stdin" do
    stdin = ruby_exe("print ARGF.read", :args => "#{@file1_name} - < #{@stdin_name}")
    stdin.should == @file1 + @stdin
  end

  it "reads the contents of the same file twice" do
    argv [@file1_name, @file1_name] do
      ARGF.read.should == @file1 + @file1
    end
  end

  with_feature :encoding do

    before :each do
      @external = Encoding.default_external
      @internal = Encoding.default_internal

      Encoding.default_external = Encoding::UTF_8
      Encoding.default_internal = nil
    end

    after :each do
      Encoding.default_external = @external
      Encoding.default_internal = @internal
    end

    it "reads the contents of the file with default encoding" do
      Encoding.default_external = Encoding::US_ASCII
      argv [@file1_name, @file2_name] do
        ARGF.read.encoding.should == Encoding::US_ASCII
      end
    end
  end
end
