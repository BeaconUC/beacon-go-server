package database

type PublicProfilesSelect struct {
	CreatedAt   string  `json:"created_at"`
	FirstName   string  `json:"first_name"`
	Id          int64   `json:"id"`
	LastName    string  `json:"last_name"`
	PhoneNumber *string `json:"phone_number"`
	PublicId    string  `json:"public_id"`
	Role        string  `json:"role"`
	UpdatedAt   *string `json:"updated_at"`
	UserId      string  `json:"user_id"`
}

type PublicProfilesInsert struct {
	CreatedAt   *string `json:"created_at"`
	FirstName   string  `json:"first_name"`
	Id          *int64  `json:"id"`
	LastName    string  `json:"last_name"`
	PhoneNumber *string `json:"phone_number"`
	PublicId    *string `json:"public_id"`
	Role        *string `json:"role"`
	UpdatedAt   *string `json:"updated_at"`
	UserId      string  `json:"user_id"`
}

type PublicProfilesUpdate struct {
	CreatedAt   *string `json:"created_at"`
	FirstName   *string `json:"first_name"`
	Id          *int64  `json:"id"`
	LastName    *string `json:"last_name"`
	PhoneNumber *string `json:"phone_number"`
	PublicId    *string `json:"public_id"`
	Role        *string `json:"role"`
	UpdatedAt   *string `json:"updated_at"`
	UserId      *string `json:"user_id"`
}

type PublicProvincesSelect struct {
	Boundary       interface{} `json:"boundary"`
	CreatedAt      string      `json:"created_at"`
	Id             int64       `json:"id"`
	Name           string      `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	PublicId       string      `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicProvincesInsert struct {
	Boundary       interface{} `json:"boundary"`
	CreatedAt      *string     `json:"created_at"`
	Id             *int64      `json:"id"`
	Name           string      `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	PublicId       *string     `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicProvincesUpdate struct {
	Boundary       interface{} `json:"boundary"`
	CreatedAt      *string     `json:"created_at"`
	Id             *int64      `json:"id"`
	Name           *string     `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	PublicId       *string     `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicCitiesSelect struct {
	Boundary       interface{} `json:"boundary"`
	CreatedAt      string      `json:"created_at"`
	Id             int64       `json:"id"`
	Name           string      `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	ProvinceId     int64       `json:"province_id"`
	PublicId       string      `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicCitiesInsert struct {
	Boundary       interface{} `json:"boundary"`
	CreatedAt      *string     `json:"created_at"`
	Id             *int64      `json:"id"`
	Name           string      `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	ProvinceId     int64       `json:"province_id"`
	PublicId       *string     `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicCitiesUpdate struct {
	Boundary       interface{} `json:"boundary"`
	CreatedAt      *string     `json:"created_at"`
	Id             *int64      `json:"id"`
	Name           *string     `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	ProvinceId     *int64      `json:"province_id"`
	PublicId       *string     `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicFeedersSelect struct {
	Boundary     interface{} `json:"boundary"`
	CreatedAt    string      `json:"created_at"`
	FeederNumber int64       `json:"feeder_number"`
	Id           int64       `json:"id"`
	PublicId     string      `json:"public_id"`
	UpdatedAt    *string     `json:"updated_at"`
}

type PublicFeedersInsert struct {
	Boundary     interface{} `json:"boundary"`
	CreatedAt    *string     `json:"created_at"`
	FeederNumber int64       `json:"feeder_number"`
	Id           *int64      `json:"id"`
	PublicId     *string     `json:"public_id"`
	UpdatedAt    *string     `json:"updated_at"`
}

type PublicFeedersUpdate struct {
	Boundary     interface{} `json:"boundary"`
	CreatedAt    *string     `json:"created_at"`
	FeederNumber *int64      `json:"feeder_number"`
	Id           *int64      `json:"id"`
	PublicId     *string     `json:"public_id"`
	UpdatedAt    *string     `json:"updated_at"`
}

type PublicBarangaysSelect struct {
	Boundary       interface{} `json:"boundary"`
	CityId         int64       `json:"city_id"`
	CreatedAt      string      `json:"created_at"`
	FeederId       *int64      `json:"feeder_id"`
	Id             int64       `json:"id"`
	Name           string      `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	PublicId       string      `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicBarangaysInsert struct {
	Boundary       interface{} `json:"boundary"`
	CityId         int64       `json:"city_id"`
	CreatedAt      *string     `json:"created_at"`
	FeederId       *int64      `json:"feeder_id"`
	Id             *int64      `json:"id"`
	Name           string      `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	PublicId       *string     `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicBarangaysUpdate struct {
	Boundary       interface{} `json:"boundary"`
	CityId         *int64      `json:"city_id"`
	CreatedAt      *string     `json:"created_at"`
	FeederId       *int64      `json:"feeder_id"`
	Id             *int64      `json:"id"`
	Name           *string     `json:"name"`
	Population     *int32      `json:"population"`
	PopulationYear *int16      `json:"population_year"`
	PublicId       *string     `json:"public_id"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicOutagesSelect struct {
	ActualRestorationTime       *string  `json:"actual_restoration_time"`
	ConfidencePercentage        *float64 `json:"confidence_percentage"`
	ConfirmedBy                 *int64   `json:"confirmed_by"`
	CreatedAt                   string   `json:"created_at"`
	Description                 *string  `json:"description"`
	EstimatedAffectedPopulation *int32   `json:"estimated_affected_population"`
	EstimatedRestorationTime    *string  `json:"estimated_restoration_time"`
	Id                          int64    `json:"id"`
	NumberOfReports             *int32   `json:"number_of_reports"`
	OutageType                  string   `json:"outage_type"`
	PublicId                    string   `json:"public_id"`
	ResolvedBy                  *int64   `json:"resolved_by"`
	StartTime                   *string  `json:"start_time"`
	Status                      string   `json:"status"`
	Title                       *string  `json:"title"`
	UpdatedAt                   *string  `json:"updated_at"`
}

type PublicOutagesInsert struct {
	ActualRestorationTime       *string  `json:"actual_restoration_time"`
	ConfidencePercentage        *float64 `json:"confidence_percentage"`
	ConfirmedBy                 *int64   `json:"confirmed_by"`
	CreatedAt                   *string  `json:"created_at"`
	Description                 *string  `json:"description"`
	EstimatedAffectedPopulation *int32   `json:"estimated_affected_population"`
	EstimatedRestorationTime    *string  `json:"estimated_restoration_time"`
	Id                          *int64   `json:"id"`
	NumberOfReports             *int32   `json:"number_of_reports"`
	OutageType                  *string  `json:"outage_type"`
	PublicId                    *string  `json:"public_id"`
	ResolvedBy                  *int64   `json:"resolved_by"`
	StartTime                   *string  `json:"start_time"`
	Status                      *string  `json:"status"`
	Title                       *string  `json:"title"`
	UpdatedAt                   *string  `json:"updated_at"`
}

type PublicOutagesUpdate struct {
	ActualRestorationTime       *string  `json:"actual_restoration_time"`
	ConfidencePercentage        *float64 `json:"confidence_percentage"`
	ConfirmedBy                 *int64   `json:"confirmed_by"`
	CreatedAt                   *string  `json:"created_at"`
	Description                 *string  `json:"description"`
	EstimatedAffectedPopulation *int32   `json:"estimated_affected_population"`
	EstimatedRestorationTime    *string  `json:"estimated_restoration_time"`
	Id                          *int64   `json:"id"`
	NumberOfReports             *int32   `json:"number_of_reports"`
	OutageType                  *string  `json:"outage_type"`
	PublicId                    *string  `json:"public_id"`
	ResolvedBy                  *int64   `json:"resolved_by"`
	StartTime                   *string  `json:"start_time"`
	Status                      *string  `json:"status"`
	Title                       *string  `json:"title"`
	UpdatedAt                   *string  `json:"updated_at"`
}

type PublicOutageUpdatesSelect struct {
	CreatedAt   string  `json:"created_at"`
	Description *string `json:"description"`
	Id          int64   `json:"id"`
	NewStatus   string  `json:"new_status"`
	OldStatus   string  `json:"old_status"`
	OutageId    int64   `json:"outage_id"`
	PublicId    string  `json:"public_id"`
	UserId      int64   `json:"user_id"`
}

type PublicOutageUpdatesInsert struct {
	CreatedAt   *string `json:"created_at"`
	Description *string `json:"description"`
	Id          *int64  `json:"id"`
	NewStatus   string  `json:"new_status"`
	OldStatus   string  `json:"old_status"`
	OutageId    int64   `json:"outage_id"`
	PublicId    *string `json:"public_id"`
	UserId      int64   `json:"user_id"`
}

type PublicOutageUpdatesUpdate struct {
	CreatedAt   *string `json:"created_at"`
	Description *string `json:"description"`
	Id          *int64  `json:"id"`
	NewStatus   *string `json:"new_status"`
	OldStatus   *string `json:"old_status"`
	OutageId    *int64  `json:"outage_id"`
	PublicId    *string `json:"public_id"`
	UserId      *int64  `json:"user_id"`
}

type PublicOutageReportsSelect struct {
	Description    *string     `json:"description"`
	Id             int64       `json:"id"`
	ImageUrl       *string     `json:"image_url"`
	LinkedOutageId *int64      `json:"linked_outage_id"`
	Location       interface{} `json:"location"`
	PublicId       string      `json:"public_id"`
	ReportedAt     string      `json:"reported_at"`
	ReportedBy     *int64      `json:"reported_by"`
	Status         string      `json:"status"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicOutageReportsInsert struct {
	Description    *string     `json:"description"`
	Id             *int64      `json:"id"`
	ImageUrl       *string     `json:"image_url"`
	LinkedOutageId *int64      `json:"linked_outage_id"`
	Location       interface{} `json:"location"`
	PublicId       *string     `json:"public_id"`
	ReportedAt     *string     `json:"reported_at"`
	ReportedBy     *int64      `json:"reported_by"`
	Status         *string     `json:"status"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicOutageReportsUpdate struct {
	Description    *string     `json:"description"`
	Id             *int64      `json:"id"`
	ImageUrl       *string     `json:"image_url"`
	LinkedOutageId *int64      `json:"linked_outage_id"`
	Location       interface{} `json:"location"`
	PublicId       *string     `json:"public_id"`
	ReportedAt     *string     `json:"reported_at"`
	ReportedBy     *int64      `json:"reported_by"`
	Status         *string     `json:"status"`
	UpdatedAt      *string     `json:"updated_at"`
}

type PublicAffectedAreasSelect struct {
	BarangayId int64  `json:"barangay_id"`
	CreatedAt  string `json:"created_at"`
	Id         int64  `json:"id"`
	OutageId   int64  `json:"outage_id"`
}

type PublicAffectedAreasInsert struct {
	BarangayId int64   `json:"barangay_id"`
	CreatedAt  *string `json:"created_at"`
	Id         *int64  `json:"id"`
	OutageId   int64   `json:"outage_id"`
}

type PublicAffectedAreasUpdate struct {
	BarangayId *int64  `json:"barangay_id"`
	CreatedAt  *string `json:"created_at"`
	Id         *int64  `json:"id"`
	OutageId   *int64  `json:"outage_id"`
}

type PublicWeatherDataSelect struct {
	AtmosphericPressure  *int32   `json:"atmospheric_pressure"`
	CityId               int64    `json:"city_id"`
	ConditionDescription *string  `json:"condition_description"`
	ConditionMain        *string  `json:"condition_main"`
	CreatedAt            string   `json:"created_at"`
	FeelsLike            *float64 `json:"feels_like"`
	Humidity             *int32   `json:"humidity"`
	Id                   int64    `json:"id"`
	Precipitation        *float64 `json:"precipitation"`
	PublicId             string   `json:"public_id"`
	RecordedAt           string   `json:"recorded_at"`
	Temperature          float64  `json:"temperature"`
	WindSpeed            *float64 `json:"wind_speed"`
}

type PublicWeatherDataInsert struct {
	AtmosphericPressure  *int32   `json:"atmospheric_pressure"`
	CityId               int64    `json:"city_id"`
	ConditionDescription *string  `json:"condition_description"`
	ConditionMain        *string  `json:"condition_main"`
	CreatedAt            *string  `json:"created_at"`
	FeelsLike            *float64 `json:"feels_like"`
	Humidity             *int32   `json:"humidity"`
	Id                   *int64   `json:"id"`
	Precipitation        *float64 `json:"precipitation"`
	PublicId             *string  `json:"public_id"`
	RecordedAt           string   `json:"recorded_at"`
	Temperature          float64  `json:"temperature"`
	WindSpeed            *float64 `json:"wind_speed"`
}

type PublicWeatherDataUpdate struct {
	AtmosphericPressure  *int32   `json:"atmospheric_pressure"`
	CityId               *int64   `json:"city_id"`
	ConditionDescription *string  `json:"condition_description"`
	ConditionMain        *string  `json:"condition_main"`
	CreatedAt            *string  `json:"created_at"`
	FeelsLike            *float64 `json:"feels_like"`
	Humidity             *int32   `json:"humidity"`
	Id                   *int64   `json:"id"`
	Precipitation        *float64 `json:"precipitation"`
	PublicId             *string  `json:"public_id"`
	RecordedAt           *string  `json:"recorded_at"`
	Temperature          *float64 `json:"temperature"`
	WindSpeed            *float64 `json:"wind_speed"`
}

type PublicSystemConfigSelect struct {
	Description *string `json:"description"`
	Id          int64   `json:"id"`
	Key         string  `json:"key"`
	PublicId    string  `json:"public_id"`
	UpdatedAt   *string `json:"updated_at"`
	UpdatedBy   *int64  `json:"updated_by"`
	Value       string  `json:"value"`
}

type PublicSystemConfigInsert struct {
	Description *string `json:"description"`
	Id          *int64  `json:"id"`
	Key         string  `json:"key"`
	PublicId    *string `json:"public_id"`
	UpdatedAt   *string `json:"updated_at"`
	UpdatedBy   *int64  `json:"updated_by"`
	Value       string  `json:"value"`
}

type PublicSystemConfigUpdate struct {
	Description *string `json:"description"`
	Id          *int64  `json:"id"`
	Key         *string `json:"key"`
	PublicId    *string `json:"public_id"`
	UpdatedAt   *string `json:"updated_at"`
	UpdatedBy   *int64  `json:"updated_by"`
	Value       *string `json:"value"`
}

type PublicApiKeysSelect struct {
	ApiKey             string  `json:"api_key"`
	CreatedAt          string  `json:"created_at"`
	CreatedBy          *int64  `json:"created_by"`
	ExpiresAt          *string `json:"expires_at"`
	Id                 int64   `json:"id"`
	IsActive           bool    `json:"is_active"`
	Name               string  `json:"name"`
	PublicId           string  `json:"public_id"`
	RateLimitPerMinute *int32  `json:"rate_limit_per_minute"`
	SecretKey          *string `json:"secret_key"`
	ServiceName        *string `json:"service_name"`
}

type PublicApiKeysInsert struct {
	ApiKey             string  `json:"api_key"`
	CreatedAt          *string `json:"created_at"`
	CreatedBy          *int64  `json:"created_by"`
	ExpiresAt          *string `json:"expires_at"`
	Id                 *int64  `json:"id"`
	IsActive           *bool   `json:"is_active"`
	Name               string  `json:"name"`
	PublicId           *string `json:"public_id"`
	RateLimitPerMinute *int32  `json:"rate_limit_per_minute"`
	SecretKey          *string `json:"secret_key"`
	ServiceName        *string `json:"service_name"`
}

type PublicApiKeysUpdate struct {
	ApiKey             *string `json:"api_key"`
	CreatedAt          *string `json:"created_at"`
	CreatedBy          *int64  `json:"created_by"`
	ExpiresAt          *string `json:"expires_at"`
	Id                 *int64  `json:"id"`
	IsActive           *bool   `json:"is_active"`
	Name               *string `json:"name"`
	PublicId           *string `json:"public_id"`
	RateLimitPerMinute *int32  `json:"rate_limit_per_minute"`
	SecretKey          *string `json:"secret_key"`
	ServiceName        *string `json:"service_name"`
}

type PublicProfileSettingsSelect struct {
	CreatedAt     string      `json:"created_at"`
	DynamicColor  bool        `json:"dynamic_color"`
	ExtraSettings interface{} `json:"extra_settings"`
	FontScale     float64     `json:"font_scale"`
	Id            int64       `json:"id"`
	Language      string      `json:"language"`
	ProfileId     *int64      `json:"profile_id"`
	ReduceMotion  bool        `json:"reduce_motion"`
	Theme         string      `json:"theme"`
	UpdatedAt     *string     `json:"updated_at"`
}

type PublicProfileSettingsInsert struct {
	CreatedAt     *string     `json:"created_at"`
	DynamicColor  *bool       `json:"dynamic_color"`
	ExtraSettings interface{} `json:"extra_settings"`
	FontScale     *float64    `json:"font_scale"`
	Id            *int64      `json:"id"`
	Language      *string     `json:"language"`
	ProfileId     *int64      `json:"profile_id"`
	ReduceMotion  *bool       `json:"reduce_motion"`
	Theme         *string     `json:"theme"`
	UpdatedAt     *string     `json:"updated_at"`
}

type PublicProfileSettingsUpdate struct {
	CreatedAt     *string     `json:"created_at"`
	DynamicColor  *bool       `json:"dynamic_color"`
	ExtraSettings interface{} `json:"extra_settings"`
	FontScale     *float64    `json:"font_scale"`
	Id            *int64      `json:"id"`
	Language      *string     `json:"language"`
	ProfileId     *int64      `json:"profile_id"`
	ReduceMotion  *bool       `json:"reduce_motion"`
	Theme         *string     `json:"theme"`
	UpdatedAt     *string     `json:"updated_at"`
}

type PublicCrewsSelect struct {
	CreatedAt   string  `json:"created_at"`
	CrewType    string  `json:"crew_type"`
	Description *string `json:"description"`
	Id          int64   `json:"id"`
	Name        string  `json:"name"`
	PublicId    string  `json:"public_id"`
	UpdatedAt   *string `json:"updated_at"`
}

type PublicCrewsInsert struct {
	CreatedAt   *string `json:"created_at"`
	CrewType    *string `json:"crew_type"`
	Description *string `json:"description"`
	Id          *int64  `json:"id"`
	Name        string  `json:"name"`
	PublicId    *string `json:"public_id"`
	UpdatedAt   *string `json:"updated_at"`
}

type PublicCrewsUpdate struct {
	CreatedAt   *string `json:"created_at"`
	CrewType    *string `json:"crew_type"`
	Description *string `json:"description"`
	Id          *int64  `json:"id"`
	Name        *string `json:"name"`
	PublicId    *string `json:"public_id"`
	UpdatedAt   *string `json:"updated_at"`
}

type PublicAssignmentsSelect struct {
	AssignedAt string  `json:"assigned_at"`
	CrewId     int64   `json:"crew_id"`
	Id         int64   `json:"id"`
	Notes      *string `json:"notes"`
	OutageId   int64   `json:"outage_id"`
	PublicId   string  `json:"public_id"`
	Status     string  `json:"status"`
	UpdatedAt  *string `json:"updated_at"`
}

type PublicAssignmentsInsert struct {
	AssignedAt *string `json:"assigned_at"`
	CrewId     int64   `json:"crew_id"`
	Id         *int64  `json:"id"`
	Notes      *string `json:"notes"`
	OutageId   int64   `json:"outage_id"`
	PublicId   *string `json:"public_id"`
	Status     *string `json:"status"`
	UpdatedAt  *string `json:"updated_at"`
}

type PublicAssignmentsUpdate struct {
	AssignedAt *string `json:"assigned_at"`
	CrewId     *int64  `json:"crew_id"`
	Id         *int64  `json:"id"`
	Notes      *string `json:"notes"`
	OutageId   *int64  `json:"outage_id"`
	PublicId   *string `json:"public_id"`
	Status     *string `json:"status"`
	UpdatedAt  *string `json:"updated_at"`
}

type PublicOutageSummarySelect struct {
	AffectedBarangayCount       *int64  `json:"affected_barangay_count"`
	EstimatedPopulationAffected *int64  `json:"estimated_population_affected"`
	Id                          *int64  `json:"id"`
	PublicId                    *string `json:"public_id"`
	Status                      *string `json:"status"`
}
