package dag

type Vertex interface {
	ID() string
	Value() interface{}
}

type vertex struct {
	id  string
	val interface{}
}

func (v *vertex) ID() string {
	return v.id
}

func (v *vertex) Value() interface{} {
	return v.val
}
