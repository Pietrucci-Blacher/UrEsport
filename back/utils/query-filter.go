package utils

type QueryFilter struct {
	Page  int    `json:"page"`
	Limit int    `json:"limit"`
	Skip  int    `json:"skip"`
	Where string `json:"where"`
}

func NewQueryFilter(page, limit int, where string) QueryFilter {
	return QueryFilter{
		Page:  page,
		Limit: limit,
		Skip:  (page - 1) * limit,
		Where: where,
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
