package main

const (
	ProfileProduction  = "production"
	ProfileDevelopment = "development"
)

// Config represents the site-wide configuration, such as branding, URLs,
// paths, and runtime environments.
type Config struct {
	Title        string
	BaseURL      string
	Profile      string
	ImagesPath   string
	ArticlesPath string
	PagesPath    string
}

func (c *Config) IsProduction() bool {
	return c.Profile == ProfileProduction
}

func (c *Config) IsDevelopment() bool {
	return c.Profile == ProfileDevelopment
}

func NewDefaultConfig() *Config {
	return &Config{
		Title:   "Alex Blackie",
		BaseURL: "https://www.alexblackie.com",
		Profile: ProfileDevelopment,
	}
}
