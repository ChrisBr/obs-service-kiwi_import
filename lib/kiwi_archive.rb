class KiwiArchive
  attr_accessor :archive_path, :output_path, :config_name, :extracted
  alias extracted? extracted

  def initialize(archive_path, output_path, config_name = 'config.xml')
    self.archive_path = archive_path
    self.output_path = output_path
    self.config_name = config_name
    self.extracted = false
  end

  def create_import!
    extract!
    create_root_archive!
    rename_kiwi_config!
  end

  def config
    if extracted?
      File.read(config_path).to_s
    else
      raise 'KiwiArchive not extracted yet. Use #create_import! first.'
    end
  end

  def config=(content)
    if extracted?
      File.write(File.join(output_path, config_name), content)
    else
      raise 'KiwiArchive not extracted yet. Use #create_import! first.'
    end
  end

  private

  def config_path
    File.join(output_path, config_name)
  end

  def extract!
    system("tar", "Jxf", archive_path, "-C", output_path)
    self.extracted = true
  end

  def create_root_archive!
    system("tar", "cf", File.join(output_path, 'root.tar'), "-C", File.join(output_path, 'root/'), "etc/", "studio/")
    FileUtils.rm_rf(File.join(output_path, 'root'))
  end

  def rename_kiwi_config!
    File.rename(File.join(output_path, config_name), File.join(output_path, 'config.kiwi'))
    self.config_name = "config.kiwi"
  end
end
