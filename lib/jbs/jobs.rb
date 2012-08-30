module Jbs
  class Jobs
    JOBS = [
      'primary' => {:sha => '', :branch => 'master', :task => 'ci:run'},
      'other'   => {:sha => '', :branch => 'other',  :task => 'ci:other_run'},
    ]
  end
end
