import Foundation

internal struct JSON {
    var raw: Any
}

extension JSON: Polymorphic {
    var string: String? {
        if let string = raw as? String {
            return string
        } else if let bool = self.bool {
            return bool.description
        } else if let int = self.int {
            return int.string
        } else if let double = self.double {
            return double.description
        } else {
            return nil
        }
    }

    var int: Int? {
        return raw as? Int
    }

    var uint: UInt? {
        return raw as? UInt
    }

    var double: Double? {
        if let double = raw as? Double {
            return double
        } else if let int = int {
            return int.double
        } else if let uint = uint {
            return uint.double
        }
        return nil
    }

    var bool: Bool? {
        return raw as? Bool
    }

    var dictionary: [String : JSON]? {
        guard let dict = raw as? [String: Any] else {
            return nil
        }

        return dict.mapValues { .init(raw: $0) }
    }

    var isNull: Bool {
        return raw as? NSNull != nil
    }

    var array: [JSON]? {
        guard let array = raw as? [Any] else {
            return nil
        }

        return array.map { .init(raw: $0) }
    }
}
