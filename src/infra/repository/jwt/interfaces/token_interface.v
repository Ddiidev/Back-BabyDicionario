module interfaces

pub interface IToken[T] {
	header    string
	signature string
	payload   IPayload[T]
}
