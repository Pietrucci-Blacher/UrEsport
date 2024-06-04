package utils

type QueryFilter struct {
	Page  int    `json:"page"`
	Limit int    `json:"limit"`
	Skip  int    `json:"skip"`
	Where string `json:"where"`
	Sort  string `json:"sort"`
}

func NewQueryFilter(page, limit int, where, sort string) QueryFilter {
	if page < 1 {
		page = 1
	}
	if limit < 1 {
		limit = 10
	}
	if sort == "" {
		sort = "id asc"
	}

	return QueryFilter{
		Page:  page,
		Limit: limit,
		Skip:  (page - 1) * limit,
		Where: where,
		Sort:  sort,
	}
}

func (q *QueryFilter) GetPage() int {
	return q.Page
}

func (q *QueryFilter) GetLimit() int {
	return q.Limit
}

func (q *QueryFilter) GetWhere() string {
	return q.Where
}

func (q *QueryFilter) GetSkip() int {
	return q.Skip
}

func (q *QueryFilter) GetSort() string {
	return q.Sort
}
