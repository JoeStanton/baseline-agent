class BaselineAgent
  desc 'event:deploy', "Create a deployment event"

  method_option 'repo', required: false
  method_option 'branch', required: false
  method_option 'commit', required: false
  method_option 'url', required: false
  method_option 'host', required: false
  method_option 'service', required: true

  define_method 'event:deploy' do
    branch = `git rev-parse --abbrev-ref HEAD`.strip
    sha, msg, author = `git log -n 1 --pretty="%h:%s:%an"`.strip.split(":", 3)

    origin = `git config --get remote.origin.url`
    if origin.include? "github"
      user, repo = origin.match(/([\w-]+)\/([\w-]+).git$/).captures
      url = "https://github.com/#{user}/#{repo}/commit/#{sha}"
    end

    send_event({
      type: "Deployment",
      repo: options.repo || "#{user}/#{repo}",
      branch: options.branch || branch,
      message: options.commit || "#{msg} (#{sha})",
      url: options.url || url,
      service_slug: options.service,
      author: options.author || author,
      host_slug: options.host || Socket.gethostname
    })
  end
end
