package utils

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
	var err error
	var queryFilter QueryFilter = QueryFilter{}
	var page, limit int = 1, 10
	var populate []string = []string{}
	var sort string = "id asc"
	var where map[string]any = make(map[string]any)

	matchWhere, _ := regexp.Compile(`where\[.*\]`)
	replaceWhere, _ := regexp.Compile(`where\[(.*)\]`)

	for key, value := range query {
		if matchWhere.MatchString(key) {
			replacedKey := replaceWhere.ReplaceAllString(key, "$1")
			where[replacedKey] = value[0]
			continue
		}

		switch key {
		case "page":
			page, err = strconv.Atoi(value[0])
		case "limit":
			limit, err = strconv.Atoi(value[0])
		case "populate":
			populate = strings.Split(value[0], ",")
		case "sort":
			sort = value[0]
		}

		if err != nil {
			return queryFilter, err
		}
	}

	queryFilter = QueryFilter{
		Page:     page,
		Limit:    limit,
		Skip:     (page - 1) * limit,
		Where:    where,
		Sort:     sort,
		Populate: populate,
	}

	return queryFilter, nil
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
