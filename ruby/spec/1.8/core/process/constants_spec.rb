
describe "Process::Constants" do
  specify "the constants" do
    Process::WNOHANG.should == 1
    Process::WUNTRACED.should == 2
    Process::PRIO_PROCESS.should == 0
    Process::PRIO_PGRP.should == 1
    Process::PRIO_USER.should == 2
    Process::RLIM_INFINITY.should == 18446744073709551615
    Process::RLIM_SAVED_MAX.should == 18446744073709551615
    Process::RLIM_SAVED_CUR.should == 18446744073709551615
    Process::RLIMIT_CPU.should == 0
    Process::RLIMIT_FSIZE.should == 1
    Process::RLIMIT_DATA.should == 2
    Process::RLIMIT_STACK.should == 3
    Process::RLIMIT_CORE.should == 4
    Process::RLIMIT_RSS.should == 5
    Process::RLIMIT_NPROC.should == 6
    Process::RLIMIT_NOFILE.should == 7
    Process::RLIMIT_MEMLOCK.should == 8
    Process::RLIMIT_AS.should == 9
  end

  platform_is :os => [:netbsd, :freebsd] do
    specify "Process::RLIMIT_SBSIZE" do
      Process::RLIMIT_SBSIZE.should == nil # FIXME: what's it equal?
    end
  end
end
