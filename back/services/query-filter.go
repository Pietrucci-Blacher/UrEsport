package services

import (
	"regexp"
	"strconv"
	"strings"
)

type QueryFilter struct {
	Page     int            `json:"page"`
	Limit    int            `json:"limit"`
	Skip     int            `json:"skip"`
	Where    map[string]any `json:"where"`
	Sort     string         `json:"sort"`
	Populate []string       `json:"populate"`
}

func NewQueryFilter(query map[string][]string) (QueryFilter, error) {
	queryFilter := QueryFilter{
		Page:     1,
		Limit:    10,
		Skip:     0,
		Where:    make(map[string]any),
		Sort:     "id asc",
		Populate: []string{},
	}

	if err := queryFilter.initQuery(query); err != nil {
		return QueryFilter{}, err
	}

	return queryFilter, nil
}

func (q *QueryFilter) initQuery(query map[string][]string) error {
	var err error

	matchWhere, _ := regexp.Compile(`where\[.*\]`)
	replaceWhere, _ := regexp.Compile(`where\[(.*)\]`)

	for key, value := range query {
		if matchWhere.MatchString(key) {
			replacedKey := replaceWhere.ReplaceAllString(key, "$1")
			q.Where[replacedKey] = value[0]
			continue
		}

		switch key {
		case "page":
			q.Page, err = strconv.Atoi(value[0])
		case "limit":
			q.Limit, err = strconv.Atoi(value[0])
		case "populate":
			q.Populate = strings.Split(value[0], ",")
		case "sort":
			q.Sort = value[0]
		}

		if err != nil {
			return err
		}
	}

	q.Skip = (q.Page - 1) * q.Limit

	return nil
}

func (q *QueryFilter) GetPage() int {
	return q.Page
}

func (q *QueryFilter) GetLimit() int {
	return q.Limit
}

func (q *QueryFilter) GetWhere() map[string]any {
	return q.Where
}

func (q *QueryFilter) GetSkip() int {
	return q.Skip
}

func (q *QueryFilter) GetSort() string {
	return q.Sort
}

func (q *QueryFilter) GetPopulate() []string {
	return q.Populate
}
