# frozen_string_literal: true
class ApplicationOperation < ActiveOperation::Base
  def operation_runtime_seconds
    (@operation_runtime_stop || Process.clock_gettime(Process::CLOCK_MONOTONIC)) - @operation_runtime_start
  end

  around do |instance, executable|
    @operation_runtime_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    executable.call
    @operation_runtime_stop = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    Rails.logger.tagged(self.class) { |l| l.info("execution time #{ instance.operation_runtime_seconds } seconds")}
  end
end
